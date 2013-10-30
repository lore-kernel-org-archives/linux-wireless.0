Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3J3QZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 12:25:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] hwsim tests: use argparse module
Date: Wed, 30 Oct 2013 17:25:13 +0100
Message-Id: <1383150313-4155-1-git-send-email-johannes@sipsolutions.net> (sfid-20131030_172521_552346_2306CF4D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of re-implementing a command-line parser, use the
argparse module.

The only real change (I hope) is that the test module must
now be given to the -f option without the .py suffix.

Also, --help now works, and if a test module/test name is
given that doesn't exist, the valid list is printed.

Signed-hostap: Johannes Berg <johannes.berg@intel.com>
---
 tests/hwsim/run-all.sh   |   4 +-
 tests/hwsim/run-tests.py | 144 +++++++++++++++++++++++++----------------------
 2 files changed, 80 insertions(+), 68 deletions(-)

diff --git a/tests/hwsim/run-all.sh b/tests/hwsim/run-all.sh
index 07006af..9471dd8 100755
--- a/tests/hwsim/run-all.sh
+++ b/tests/hwsim/run-all.sh
@@ -24,7 +24,7 @@ if [ "x$1" = "xconcurrent-valgrind" ]; then
     DATE=`ls -1tr $LOGDIR | tail -1 | cut -f1 -d-`
     rm $LOGDIR/last-debug
     for i in autogo discovery grpform; do
-	./run-tests.py -l $LOGDIR/$DATE-run-$i $DB -e $LOGDIR/$DATE-failed-$i -r $LOGDIR/results.txt -f test_p2p_$i.py || errors=1
+	./run-tests.py -l $LOGDIR/$DATE-run-$i $DB -e $LOGDIR/$DATE-failed-$i -r $LOGDIR/results.txt -f test_p2p_$i || errors=1
 	cat $LOGDIR/$DATE-run-$i >> $LOGDIR/last-debug
     done
     ./stop-wifi.sh
@@ -45,7 +45,7 @@ elif [ "x$1" = "xconcurrent" ]; then
     DATE=`ls -1tr $LOGDIR | tail -1 | cut -f1 -d-`
     rm $LOGDIR/last-debug
     for i in autogo discovery grpform; do
-	./run-tests.py -l $LOGDIR/$DATE-run-$i $DB -e $LOGDIR/$DATE-failed-$i -r $LOGDIR/results.txt -f test_p2p_$i.py || errors=1
+	./run-tests.py -l $LOGDIR/$DATE-run-$i $DB -e $LOGDIR/$DATE-failed-$i -r $LOGDIR/results.txt -f test_p2p_$i || errors=1
 	cat $LOGDIR/$DATE-run-$i >> $LOGDIR/last-debug
     done
     ./stop-wifi.sh
diff --git a/tests/hwsim/run-tests.py b/tests/hwsim/run-tests.py
index e319eec..9644b4a 100755
--- a/tests/hwsim/run-tests.py
+++ b/tests/hwsim/run-tests.py
@@ -11,6 +11,7 @@ import re
 import sys
 import time
 from datetime import datetime
+import argparse
 
 import logging
 logger = logging.getLogger(__name__)
@@ -47,49 +48,74 @@ def report(conn, build, commit, run, test, result, diff):
             print "sql: %r" % (params, )
 
 def main():
-    test_file = None
-    error_file = None
-    log_file = None
-    results_file = None
-    conn = None
+    tests = []
+    test_modules = []
+    for t in os.listdir("."):
+        m = re.match(r'(test_.*)\.py$', t)
+        if m:
+            logger.debug("Import test cases from " + t)
+            mod = __import__(m.group(1))
+            test_modules.append(mod.__name__)
+            for s in dir(mod):
+                if s.startswith("test_"):
+                    func = mod.__dict__.get(s)
+                    tests.append(func)
+    test_names = list(set([t.__name__ for t in tests]))
+
     run = None
-    build = None
     commit = None
-    idx = 1
     print_res = False
-    if len(sys.argv) > 1 and sys.argv[1] == '-d':
-        logging.basicConfig(level=logging.DEBUG)
-        idx = idx + 1
-    elif len(sys.argv) > 1 and sys.argv[1] == '-q':
-        logging.basicConfig(level=logging.WARNING)
-        print_res = True
-        idx = idx + 1
-    elif len(sys.argv) > 2 and sys.argv[1] == '-l':
-        log_file = sys.argv[2]
-        logging.basicConfig(filename=log_file,level=logging.DEBUG)
-        idx = idx + 2
+
+    parser = argparse.ArgumentParser(description='hwsim test runner')
+    group = parser.add_mutually_exclusive_group()
+    group.add_argument('-d', const=logging.DEBUG, action='store_const',
+                       dest='loglevel', default=logging.INFO,
+                       help="verbose debug output")
+    group.add_argument('-q', const=logging.WARNING, action='store_const',
+                       dest='loglevel', help="be quiet")
+    group.add_argument('-l', metavar='<filename>', dest='logfile',
+                       help='debug log filename')
+
+    parser.add_argument('-e', metavar="<filename>", dest='errorfile',
+                        help='error filename')
+    parser.add_argument('-r', metavar="<filename>", dest='resultsfile',
+                        help='results filename')
+    parser.add_argument('-S', metavar='<sqlite3 db>', dest='database',
+                        help='database to write results to')
+    parser.add_argument('-b', metavar='<build>', dest='build', help='build ID')
+    parser.add_argument('-L', action='store_true', dest='update_tests_db',
+                        help='List tests (and update descriptions in DB)')
+    parser.add_argument('-f', dest='testmodule', metavar='<test module>',
+                        help='execute only tests from this test module',
+                        type=str, choices=[[]] + test_modules)
+    parser.add_argument('tests', metavar='<test>', nargs='*', type=str,
+                        help='tests to run (only valid without -f)',
+                        choices=[[]] + test_names)
+
+    args = parser.parse_args()
+
+    if args.tests and args.testmodule:
+        print 'Invalid arguments - both test module and tests given'
+        sys.exit(2)
+
+    if args.logfile:
+        logging.basicConfig(filename=args.logfile,
+                            level=logging.DEBUG)
+        log_to_file = True
     else:
-        logging.basicConfig(level=logging.INFO)
-
-    while len(sys.argv) > idx:
-        if len(sys.argv) > idx + 1 and sys.argv[idx] == '-e':
-            error_file = sys.argv[idx + 1]
-            idx = idx + 2
-        elif len(sys.argv) > idx + 1 and sys.argv[idx] == '-r':
-            results_file = sys.argv[idx + 1]
-            idx = idx + 2
-        elif len(sys.argv) > idx + 1 and sys.argv[idx] == '-f':
-            test_file = sys.argv[idx + 1]
-            idx = idx + 2
-        elif len(sys.argv) > idx + 1 and sys.argv[idx] == '-S':
-            import sqlite3
-            conn = sqlite3.connect(sys.argv[idx + 1])
-            idx = idx + 2
-        elif len(sys.argv) > idx + 1 and sys.argv[idx] == '-b':
-            build = sys.argv[idx + 1]
-            idx = idx + 2
-        else:
-            break
+        logging.basicConfig(level=args.loglevel)
+        log_to_file = False
+        if args.loglevel == logging.WARNING:
+            print_res = True
+
+    error_file = args.errorfile
+    results_file = args.resultsfile
+
+    if args.database:
+        import sqlite3
+        conn = sqlite3.connect(args.database)
+    else:
+        conn = None
 
     if conn:
         run = str(int(time.time()))
@@ -101,20 +127,7 @@ def main():
         except IOError:
             pass
 
-    tests = []
-    for t in os.listdir("."):
-        m = re.match(r'(test_.*)\.py$', t)
-        if m:
-            if test_file and test_file not in t:
-                continue
-            logger.debug("Import test cases from " + t)
-            mod = __import__(m.group(1))
-            for s in dir(mod):
-                if s.startswith("test_"):
-                    func = mod.__dict__.get(s)
-                    tests.append(func)
-
-    if len(sys.argv) > idx and sys.argv[idx] == '-L':
+    if args.update_tests_db:
         for t in tests:
             print t.__name__ + " - " + t.__doc__
             if conn:
@@ -130,10 +143,6 @@ def main():
             conn.close()
         sys.exit(0)
 
-    if len(sys.argv) > idx:
-        test_filter = sys.argv[idx]
-    else:
-        test_filter = None
 
     dev0 = WpaSupplicant('wlan0', '/tmp/wpas-wlan0')
     dev1 = WpaSupplicant('wlan1', '/tmp/wpas-wlan1')
@@ -156,12 +165,15 @@ def main():
     failed = []
 
     for t in tests:
-        if test_filter:
-            if test_filter != t.__name__:
+        if args.tests:
+            if not t.__name__ in args.tests:
+                continue
+        if args.testmodule:
+            if not t.__module__ == args.testmodule:
                 continue
         reset_devs(dev, apdev)
         logger.info("START " + t.__name__)
-        if log_file:
+        if log_to_file:
             print "START " + t.__name__
             sys.stdout.flush()
         if t.__doc__:
@@ -191,11 +203,11 @@ def main():
             else:
                 passed.append(t.__name__)
                 result = "PASS"
-            report(conn, build, commit, run, t.__name__, result, diff)
+            report(conn, args.build, commit, run, t.__name__, result, diff)
             result = result + " " + t.__name__ + " "
             result = result + str(diff.total_seconds()) + " " + str(end)
             logger.info(result)
-            if log_file or print_res:
+            if log_to_file or print_res:
                 print result
                 sys.stdout.flush()
             if results_file:
@@ -207,10 +219,10 @@ def main():
             diff = end - start
             logger.info(e)
             failed.append(t.__name__)
-            report(conn, build, commit, run, t.__name__, "FAIL", diff)
+            report(conn, args.build, commit, run, t.__name__, "FAIL", diff)
             result = "FAIL " + t.__name__ + " " + str(diff.total_seconds()) + " " + str(end)
             logger.info(result)
-            if log_file:
+            if log_to_file:
                 print result
                 sys.stdout.flush()
             if results_file:
@@ -224,7 +236,7 @@ def main():
                 logger.info("Failed to issue TEST-STOP after " + t.__name__ + " for " + d.ifname)
                 logger.info(e)
 
-    if not test_filter:
+    if not args.tests:
         reset_devs(dev, apdev)
 
     if conn:
@@ -242,7 +254,7 @@ def main():
     logger.info("passed all " + str(len(passed)) + " test case(s)")
     if len(skipped):
         logger.info("skipped " + str(len(skipped)) + " test case(s)")
-    if log_file:
+    if log_to_file:
         print "passed all " + str(len(passed)) + " test case(s)"
         if len(skipped):
             print "skipped " + str(len(skipped)) + " test case(s)"
-- 
1.8.4.rc3

