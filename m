Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85606488D82
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236522; cv=none; b=JbkwKg2YdofX8MvckzxWZ4tVVyjVjDbiQz1m9ZgfnV7F4mh5samE2F5WADIv35os83A5U43UbNaJn3J2345idQKeBRbAbzie7aKpWagU2wAAfqqiJZSSHCYXCNVxaQIfqQuOrIgf0FWvaJcDPtT4thrR9NPs+CO5Yi7iZhlyhA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236522; c=relaxed/simple;
	bh=iMgmrmeBfySHY5ZM+ZW1tmd+ehN5fp061ezQDwEMvJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hoJeA/jKsOVA/8x08Jh35aUtrdWVERJZ4pUSURILIaQnQNcgwyIRp+1e6EFL6kiiKPWMzNUF21Kq2RF9Jahpx9OE5vMJZmfP5vDdfo9yec1lOEyzZivBd0sN8PtAqD/b+OkBKi+vOG7aj7M83CXjSBGd5VbolyhaaNdw4mpoI7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=nuuAcl1a; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="nuuAcl1a"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910ca6023so78440485a.2
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2026 11:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1789236519; x=1789841319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+nM61jMT2mQop3K/7RN9vY9A4c5ZEECZp4TTfH4j17E=;
        b=nuuAcl1asTNlJkCNiWdXG+oDKQNIr8r5B21xCa9s8ZQIMXKzvpW4GacR+zQOeiM7SH
         n6oUE/Dsh003e2SYRRsmtg3+D379bvbpHtmtnzwkSzJuMIK7bhZoBlcG43WVkpaVUPeC
         bvxKajzo5Q1lhM7yF2JM43qtNgnW4yjuxNjBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789236519; x=1789841319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+nM61jMT2mQop3K/7RN9vY9A4c5ZEECZp4TTfH4j17E=;
        b=W9yPFiiNOLeNHYbsjnASd+EiP9tsHxGf3VPF41eUxzJGlFRz1YZNvFS92+8Hn8Ap1L
         BYy5Os3th3XUkXsAbhWBaQ/RJHOQWm5A01f7PRSSMVSUBpxlYnhJqgj9ShZEP8/lEPto
         VHqnEOWTdl57U8ksqJq4BGKid09oKcwXDQMW1Yv0aoQhFDMCxGD/29Q+WF7C93taElMy
         dM6X0RfV1vaGhVWvD/ROzVHHQ1M98XsIqVF8NB1KkeTyjtf6Xetepb7fHdwUUvwBI7Zo
         qJOwRhCGRz5+ZWBs4ZjWxsf1ojZI0yLH9BMtsWQdMJN+mRdqoBpkS7G58adnn4Omwit0
         MStA==
X-Forwarded-Encrypted: i=1; AKwUvBxTEXjJ4shUKlCMU570p+nXU/i6BHI8SjiTPGftTXPWwUXbuK3InW+G0jcG+O7ZbQOk/YO0pys+1TosbzMQgg==@vger.kernel.org
X-Gm-Message-State: AFuF++lUciaBHtwvABrhe6HMcf1+tuUr8xUqQ1z2c11F2jxWpaNJQ+8e
	tAKi2lQyDq2bEqLSYPQ3I1jj9VswtgnWrmpqdygejuQ1QaLn15rt+25hNwYwKiYH3g==
X-Gm-Gg: AYBFou0TQICe9oeVfNkoL6EI6e3mHDnYuQGKiGLafA/hN8E9Kmd0HKC8kaN5y7p9Bpk
	tZD4KMwRYs3Fyd+/hK5N1TGh5SE5dKZqjVBfVStH5fqJ8ZhSysEN6knG3wUF3zgjf1fDWBt8JeZ
	EtUzHf2NAzoXfSJiRGgwuTxKJV8JgDmPia1yOZmEaOLIpNsKZn5KGc2Fl/ezOJID7/gvRhAZjNL
	D2nwhL+s+iptIYu0Qv0H/DyoiRYuR1sfXFQT17N68B0r5MzSneTk5tmjKbCm2yLFLGIQ/tlJJF5
	B0rOVjoVIVxR7CG9GCywuPi1A74QUDxxdstG6do1QM//v8j3sjbUI0kfK6iKNAGQcLFD5uC8Oyo
	3n4zFq6U87R8cb8KqRTiaPHJD5w4KR+dSbi35PDaA9lyeYtI8gscaCqApA0mTwAyDLwBqoapgf8
	bs/mBaO3toeEa3NSUPqvn58TPImZOlAsP4XnD34IQppkcIwRSxs6quFL5yJ65v3/Ipx8hB7nixn
	bAguHClig18QgNCilD0+5gSVrgwUD3ceQwZ51J1HFh4awyi1Xsw+iOrXzY+LK4DQUlj+ZeYPB6D
	zUxoj8EXjBYFpVh9Ryajus8=
X-Received: by 2002:a05:620a:6308:20b0:939:ed4a:dd75 with SMTP id af79cd13be357-939ed4ae3b1mr1021513885a.21.1789236519366;
        Sat, 12 Sep 2026 11:08:39 -0700 (PDT)
Received: from majuu.waya (pool-174-112-106-84.cpe.net.cable.rogers.com. [174.112.106.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120ef650a6sm52190296d6.0.2026.09.12.11.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 11:08:37 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Victor Nogueira <victor@mojatatu.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	Vega <vega@nebusec.ai>
Subject: [PATCH net repost 2/2] selftests/tc-testing: add codel/fq_codel interval boundary cases
Date: Sat, 12 Sep 2026 14:08:31 -0400
Message-Id: <QDISC-1L5H.v1.20260912080102@mojatatu.com.2>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <QDISC-1L5H.v1.20260912080102@mojatatu.com>
References: <QDISC-1L5H.v1.20260912080102@mojatatu.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add tdc cases locking the codel/fq_codel small-interval uAPI after
the dropping-loop bound (previous patch): sub-tick and two-tick
intervals are ACCEPTED (the loop bound makes them safe), the
1024us boundary is accepted, and a sub-tick target sojourn delay is
accepted (it does not participate in the control law):

  codel:     6e44/a8c3/a695/9793 - interval 1us/3us/1024us and
             target 1us accepted (rendered 0us/2us/1.02ms/0us by tc)
  fq_codel:  1b4d/3540/49c5/3e0f - interval 1us/3us/1024us and
             target 1us accepted

The positive cases match the full rendered qdisc line (tc renders
interval 1us as 0us, 3us as 2us, 1024us as 1.02ms), mirroring the
existing tests in these files.

These cases do not test the dropping-loop bound itself: tdc cannot
observe per-dequeue drop counts. c797 (fq_codel target 1 interval 1)
passes unmodified on the patched kernel, which is the uAPI evidence
for the previous patch.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 .../tc-testing/tc-tests/qdiscs/codel.json     | 72 +++++++++++++++++++
 .../tc-testing/tc-tests/qdiscs/fq_codel.json  | 72 +++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
index 6d515d0e5ed6..a894e6f0e267 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
@@ -213,5 +213,77 @@
         "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1p target 5ms interval 100ms",
         "matchCount": "1",
         "teardown": ["$TC qdisc del dev $DEV1 handle 1: root"]
+    },
+    {
+        "id": "6e44",
+        "name": "Create CODEL with 1us interval, accepted (sub-tick, uAPI locked)",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 1us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 0us",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "a8c3",
+        "name": "Create CODEL with 3us interval, accepted (two ticks)",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 3us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 2us",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "a695",
+        "name": "Create CODEL with 1024us interval boundary accepted",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 1024us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 1.02ms",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "9793",
+        "name": "Create CODEL with 1us target, accepted (target not in control law)",
+        "category": [
+            "qdisc",
+            "codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel target 1us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 0us interval 100ms",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
     }
 ]
diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
index 4ce62b857fd7..de6a1b8d954a 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
@@ -316,5 +316,77 @@
         "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 1p flows 1024 quantum.*target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64",
         "matchCount": "1",
         "teardown": ["$TC qdisc del dev $DEV1 handle 1: root"]
+    },
+    {
+        "id": "1b4d",
+        "name": "Create FQ_CODEL with 1us interval, accepted (sub-tick, uAPI locked)",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 1us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum [0-9]+ target 5ms interval 0us memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "3540",
+        "name": "Create FQ_CODEL with 3us interval, accepted (two ticks)",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 3us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum [0-9]+ target 5ms interval 2us memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "49c5",
+        "name": "Create FQ_CODEL with 1024us interval boundary accepted",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 1024us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum [0-9]+ target 5ms interval 1.02ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
+    },
+    {
+        "id": "3e0f",
+        "name": "Create FQ_CODEL with 1us target, accepted (target not in control law)",
+        "category": [
+            "qdisc",
+            "fq_codel"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [],
+        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel target 1us",
+        "expExitCode": "0",
+        "verifyCmd": "$TC qdisc show dev $DUMMY",
+        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum [0-9]+ target 0us interval 100ms memory_limit 32Mb ecn drop_batch 64",
+        "matchCount": "1",
+        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
     }
 ]
-- 
2.43.0

