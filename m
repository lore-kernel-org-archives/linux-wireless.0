Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2924549505D;
	Sat, 12 Sep 2026 20:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789245386; cv=none; b=kSsTU7sVsCAESTwpkB7w2dzBWPZrGCcXQPwYTFMNXlb9eHnWjbBmYaMfdeSZGWVnYEwyTMUtNgDkuGXhRWTu6vbINYRDyuPPvygg6nInZrBaGLjFrdN/zCGeEctvL/oifWHgHESDNXQkCDhVY3wVOWpTQleKNRxpbnhKW40aNEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789245386; c=relaxed/simple;
	bh=1vJNEFCmpsEkh10gNad3iTXuzCz6W9V9XFIpJbERUKc=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gTB0JPZto9YArqQfSJMkzKdWM1BNbDzCh/sw0RyPRSe3OVpjZxz2pUUXNmDqyvtGhtl8kdk0IpfD8pXeriqLm74kudDGUWhz1J/oMzrz01VbTYKopF1uKTebTqj/4ueU4W8zuZIdw+5VFuMOxXdhbZPVOHYSNEhcyYtnwDQYcBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnzYYeUb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnzYYeUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462061F0089B;
	Sat, 12 Sep 2026 20:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789245383;
	bh=re1FxNKOTk60DfizzkKQ/TC8pr1T40dfBa4Ili/w84A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=UnzYYeUbgihD3TMsAW7kknmPUrcQGcrqv7SX+Z7gyYGkFaAL57sOg1E+1c3Ihz9EZ
	 Uf/AuIq3bDiAQKP7wI5urYLIRsa9a9CZLt3SUD7/UDf5uU232HBFwBw9ODG+nfXJ6f
	 m0ry6Fl5vXwfwB2x2D8D6NLOnuuo9MXfrcH9O5QWcsgVDvSEdWA7WItFGla5jKfMci
	 npzSnfv7jYUPEGSyZBjPpZMeC0ZEqNwnvRf9QWcGHnY+ZVvlE5rBw+t4YvBsxYg4sw
	 usOFc8/KSbI1JNIJ5Qdgh0UbSGBtcAUY9PL9oCm3DH16Odsu/5Sn+X4bJUIDL/YWpI
	 0G/lEGbaAiQ9Q==
Subject: Re: [PATCH net repost 2/2] selftests/tc-testing: add codel/fq_codel
 interval boundary cases
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, jiri@resnulli.us, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 victor@mojatatu.com, johannes@sipsolutions.net,
 linux-wireless@vger.kernel.org, shuah@kernel.org, vega@nebusec.ai
Date: Sat, 12 Sep 2026 20:36:21 +0000
Message-ID: <178924538183.3125.10111240291445801017@kernel.org>
In-Reply-To: <QDISC-1L5H.v1.20260912080102@mojatatu.com.2>
References: <QDISC-1L5H.v1.20260912080102@mojatatu.com.2>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 2 · Low: 0

- [Medium] None of the eight added tdc cases exercise the code the
  previous patch ("net/sched: codel: bound the dropping loop per dequeue…
- [Medium] The subject ("add codel/fq_codel interval boundary cases"),
  the body ("the 1024us boundary is accepted") and the case names…

--

selftests/tc-testing: add codel/fq_codel interval boundary cases

This adds eight tdc cases (codel 6e44/a8c3/a695/9793 and fq_codel
1b4d/3540/49c5/3e0f) that create a codel or fq_codel qdisc with small
interval and target values and match the rendered qdisc dump line.  The
stated purpose is to lock the small-interval uAPI after the preceding
dropping-loop bound patch.

No Link: tags are present in the commit header.

> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
> index 6d515d0e5ed69..a894e6f0e2677 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
> @@ -213,5 +213,77 @@
>          "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1p target 5ms interval 100ms",
>          "matchCount": "1",
>          "teardown": ["$TC qdisc del dev $DEV1 handle 1: root"]
> +    },
> +    {
> +        "id": "6e44",
> +        "name": "Create CODEL with 1us interval, accepted (sub-tick, uAPI locked)",
> +        "category": [
> +            "qdisc",
> +            "codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 1us",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 0us",
> +        "matchCount": "1",
> +        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
> +    },

[Severity: Medium]
Do any of the eight added cases actually exercise the code the previous
patch changed?  Each one has an empty setup, a bare tc qdisc add as
cmdUnderTest, and a plain tc qdisc show (no -s, no traffic, no dequeue) as
verifyCmd.

Neither codel_change() in net/sched/sch_codel.c nor fq_codel_change() gained
any validation in the previous patch, which touches only include/net/codel.h
and include/net/codel_impl.h.  So the acceptance of interval 1us/3us/1024us
and target 1us, and the dumped values interval 0us/2us/1.02ms and target 0us,
look identical on an unpatched kernel.

Would these cases stay green if the max_t(u32, 1, ...) clamp in
codel_control_law() or the CODEL_MAX_DROPS_PER_DEQUEUE bound in
codel_dequeue() were reverted?  Similarly, would 9793 and 3e0f ("target not
in control law") keep passing if target were wrongly folded into
codel_control_law()?

The changelog says:

  "These cases do not test the dropping-loop bound itself: tdc cannot
   observe per-dequeue drop counts."

Is that framing accurate for the harness as a whole?  codel.json case deb1,
in this same file, already drives traffic via scapyPlugin:

        "plugins": {
            "requires": ["nsPlugin", "scapyPlugin"]
        },
        "scapy": [
            {
                "iface": "$DEV0",
                "count": 10,
                ...

and infra/qdiscs.json case c797 configures exactly the degenerate
configuration and asserts exact counters:

        "$TC qdisc add dev $DUMMY parent 1:2 handle 10: fq_codel target 1 interval 1 flows 1",
        ...
        "verifyCmd": "$TC -s -j qdisc show dev $DUMMY",
        "matchJSON": [ ... "packets": 3, "drops": 1 ... ]

Per-dequeue granularity is indeed not observable, but aggregate drop counts
under traffic appear to be.  Could the changelog say that a dynamic case was
not written, rather than that tdc cannot express one?

[ ... ]

> +    {
> +        "id": "a695",
> +        "name": "Create CODEL with 1024us interval boundary accepted",
> +        "category": [
> +            "qdisc",
> +            "codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root codel interval 1024us",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc codel 1: root refcnt [0-9]+ limit 1000p target 5ms interval 1.02ms",
> +        "matchCount": "1",
> +        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
> +    },

[Severity: Medium]
Which boundary is 1024us?  The subject says "interval boundary cases", the
body says "the 1024us boundary is accepted", and this case (plus fq_codel
49c5) is named "1024us interval boundary accepted", but I cannot find a
1024us threshold in codel.

include/net/codel.h has:

  /* CoDel uses a 1024 nsec clock, encoded in u32
   * This gives a range of 2199 seconds, because of signed compares
   */
  #define CODEL_SHIFT 10

The 1024 there is nanoseconds per tick, not microseconds.  Is this a ns/us
mix-up?  1024us just converts to 1000 ticks and renders as 1.02ms; there is
no clamp or validation at that value in codel.h, codel_impl.h, sch_codel.c or
sch_fq_codel.c.

The granularity boundary in the uAPI conversion looks like it sits at 2us:

  net/sched/sch_codel.c:codel_change() {
      u32 interval = nla_get_u32(tb[TCA_CODEL_INTERVAL]);

      WRITE_ONCE(q->params.interval,
                 ((u64)interval * NSEC_PER_USEC) >> CODEL_SHIFT);
  }

giving 1us -> 0 ticks, 2us -> 1 tick, 3us -> 2 ticks.  The added cases cover
1us and 3us and skip 2us, which is the value used in the previous patch's own
reproducer ("codel interval 2us target 1ms").  Could a case at 2us be added
and the 1024us wording in the subject, body and case names be corrected?

> diff --git a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
> index 4ce62b857fd7a..de6a1b8d954ae 100644
> --- a/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
> +++ b/tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
> @@ -316,5 +316,77 @@

[ ... ]

> +    {
> +        "id": "49c5",
> +        "name": "Create FQ_CODEL with 1024us interval boundary accepted",
> +        "category": [
> +            "qdisc",
> +            "fq_codel"
> +        ],
> +        "plugins": {
> +            "requires": "nsPlugin"
> +        },
> +        "setup": [],
> +        "cmdUnderTest": "$TC qdisc add dev $DUMMY handle 1: root fq_codel interval 1024us",
> +        "expExitCode": "0",
> +        "verifyCmd": "$TC qdisc show dev $DUMMY",
> +        "matchPattern": "qdisc fq_codel 1: root refcnt [0-9]+ limit 10240p flows 1024 quantum [0-9]+ target 5ms interval 1.02ms memory_limit 32Mb ecn drop_batch 64",
> +        "matchCount": "1",
> +        "teardown": ["$TC qdisc del dev $DUMMY handle 1: root"]
> +    },

The same two questions apply to the fq_codel cases 1b4d/3540/49c5/3e0f: they
are config-only adds plus a show, and 49c5 carries the same 1024us boundary
naming.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-1L5H.v1.20260912080102%40mojatatu.com
