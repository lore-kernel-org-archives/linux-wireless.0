Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:35547 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdFJMKO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 08:10:14 -0400
Received: by mail-wr0-f171.google.com with SMTP id q97so55523321wrb.2
        for <linux-wireless@vger.kernel.org>; Sat, 10 Jun 2017 05:10:13 -0700 (PDT)
Received: from [192.168.178.39] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id b53sm2402737eda.50.2017.06.10.05.10.11
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jun 2017 05:10:12 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [ANN] py80211-v2.0 released
Message-ID: <30732635-a6d1-df69-2248-398a417f8d1c@broadcom.com> (sfid-20170610_142323_046499_9C69786C)
Date: Sat, 10 Jun 2017 14:10:11 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has been long since v1.0 was released. Little over two years to be
specific. The project seems to capture my attention mostly when working
on new nl80211 api primitives. Anyway, decided to move to version 2.0
immediately. Mostly due to the addition of remote execution using Pyro4.

The release can be downloaded from github [1]. The repository on github
contains 3 different branches:

master		- files generated from latest stable kernel
mac-next	- files generated from mac80211-next repository
wl-testing	- files generated from wireless-testing repository

Development is done on the master branch. The other branches are rebased
on the master branch. The releases are also coming from the master branch.

changes:
--------
 * extend parsing of wiphy attributes.
 * improve policy handling introducing annotations.
 * improve extract utility.
 * introduce support for scheduled scan.
 * support nl80211 split wiphy dump feature.
 * fix translating .len in kernel policy to libnl policy.
 * support signed types in kernel policy.
 * fix os.strerror() use in CommandFailedError exception.
 * introduce support of remote execution using Pyro4
 * allow policy overrides to use by extract utility.

important note:
---------------
The extract utility can fail on the following line in nl80211.c:

        [NL80211_ATTR_MNTR_FLAGS] = { /* NLA_NESTED can't be empty */ },

This is due to the pycparser version used. This issue has been fixed
in pycparser version 2.13 [2].

[1] https://github.com/arend/py80211/releases/tag/py80211-v2.0
[2] https://github.com/eliben/pycparser/blob/master/CHANGES#L39
---
complete commit list since py80211-v1.0-alpha:
----------------------------------------------
d8441f9 py80211: wiphy: define policy for some attributes
87d5619 py80211: wiphy: add some object classes for nested wiphy attributes
d84be2e py80211: wiphy: add object class for interface limits
a020f70 py80211: wiphy: add policy for several basic type attributes
2a01f33 py80211: allow custom processing of netlink attributes
6635def py80211: base: use 'map' policy attribute to mark 2-level nested
list
ea519ac py80211: scan: add missing policy for BSS_PRESP_DATA attribute
a6ef2bb py80211: examples: remove unused function
b22753d py80211: base: get rid of nl80211_object::get_nlattr() method
ae78f88 py80211: util: deal with difference in policy definition in
extract script
b6f4979 py80211: util: fix extract script dealing with c_ast.BinaryOp
instance
f9c7ae3 py80211: base: cleanup import statements
3384c20 py80211: wiphy: use post_store_attrs() method to decode cipher
suites
3a4638f py80211: station: use post_store_attrs() method for station flags
f0e68e1 py80211: factory: introduce concept of factory for creating objects
24c39df py80211: factory: introduce factory for creating remote objects
bcc78bf py80211: introduce client-server configuration
c45e7f7 py80211: factory: define interface class for factory classes
09966bf py80211: scan: spin base scan classes off scan_request
f0fadaf py80211: scan: add sched_scan start class
2674b5c py80211: add sched_scan stop class
e4f4ee3 py80211: scan: add matchsets support for scheduled scans
ceea777 Merge pull request #2 from arend/patch-queue
395cdac py80211: scan: fix call to _add_scan_attrs() in the
sched_scan_start class
62ea048 py80211: generated files from 4.1 kernel
ed3c03d util: add __s8 type definition to extract.h
15bc332 py80211: generated files from 4.8.8 kernel
b406d57 generated: fix typo in policy.py
d714574 base: add new nl80211_cmd_base class
d859568 scan: rework scan classes using the new nl80211_cmd_base class
a4eb60c examples: add example for scheduled scan
2117240 py80211: util: use 'git describe' to obtain revinfo
fcb1c55 examples: trivial cleanup in scheduled scan example
4ea657d lib: add method to get netlink message from nl80211_cmd_base
c2cb015 lib: fix indentation issue in sched_scan_start::handle
b1daccc lib: add SPLIT_WIPHY_DUMP attribute obtaining wiphy information
0435cda lib: generated: update definitions to kernel v4.10.1
574c026 base.py: pass received error code using exception
38a7000 examples: cleanup scheduled scan example
5c8eaa5 policy: support signed types in policy
36f7d5d util: preprocess nl80211.c before passing it through the pycparser
9e3c226 util: include predefined definitions during extraction
465ac20 lib: generated: update definitions to kernel v4.11.3
cea00f2 lib: base: fix definitions of NLA_S{8,16,32,64}
2af2b70 util: translate length according kerneldoc for struct nla_policy
5db2e02 lib: generated: regenerate definitions for kernel 4.11.3
33fa85e lib: wiphy: fix wowlan trigger support policy
bf473ed lib: base: fix handling split wiphy dump messages
bb848ac lib: base: change access80211::send() to raise error
877d56d lib: scan: properly handle exceptions raised by access80211 object
06c6305 lib: detect and check split wiphy dump protocol feature support
