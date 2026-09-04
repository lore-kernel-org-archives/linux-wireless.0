Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144EE3C660C
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 19:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788549392; cv=pass; b=F6ErR9HHg74qXhRlvN3bAPSRkCKgTKuuK71oX3cn8zBauwLJRhvw+MmZuZddD5OBJNfd0dhavP1OlzMCtCx90KIGde/m4jhIPpjpA42uh2jJzpKlmjOB3IjP6hXGkW5p01thQjLgB442C94bIgHwzv3H9x7F5NtZ/8H42Vv6r6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788549392; c=relaxed/simple;
	bh=dSLn5HQBim03v9tLWNUdygFPDDMFDP1Cu81FBMYgWlg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rnxBdEjlzzh0ETLfuMnKbaRsJpan402E/3p0k4ku/T+KULVs1yYyE/xNCgOfRCfx0WsxXvjRNVA+2dHXwv1LWv+W4KafThMvU/vcbi9dzi9y0e4oaloV7OyR0EVJcY34do/1vunQN4lB2mUL7XflzTbxNgx2NR+bsaawRZKyB24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QgvCyWFg; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgvCyWFg"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a68279dd86so1862227a12.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 12:16:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788549388; cv=none;
        d=google.com; s=arc-20260327;
        b=UVV+TCh5O116eZnwgeES5YXs/2TCXVekJQQTgxdjEMKp2fki8A5vmsPTfOMjrc6CPb
         zMGY+MYnEIgYopylvdvzz85REPsJsRaRr4j4UvavFqwaJN+r7uPg97L33Rtr2GJMmqts
         EJ7rcgNxNX9f66+TqexTCOjfLV5S7aTz3czuRZV2DiK0AvFwAuV7wLUqa5MSIHD7Ge+N
         FsD9M2f1iaR/O2e+xpGaXet681mH3tzxlpQ98JwbqpJSVAJXGqV3futKR4FFmvI2WSz9
         JLKUfx4Xet2O1MjZmsnQXDAv7U0KQlZ2JClN4p7w9bLMHW8y9hdB1kxEb6SWx4N7YZl9
         SB+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZCnu/IOFqlzFGy1VhMJGeYJiUaF7CCozjN+EPzxcJ4o=;
        fh=kyUGJxJonLoHZz4Tg9rgEqPngE+pXNKX+MGgT6RbEUk=;
        b=qqi5qFoJHfWgu+3L0Pmsj+HVJONIfWkz+jKYiBCF4p8YNw/hytxF9C6qxdi5Z0Uv4a
         YP1wCbTCco3HCkbpTcLZ9svg7F8UamOfMhcKK68yCRH17aP/xhPIOWggWG9Lrzn6x2J+
         Uq8zs1yxm1dYOsf1SC5zHievY4w8krD7oNFBiKRAuZx2mn7tMQJxgbzZ+xkVoX0msOV0
         P7bYDxBl3jm5888xlJepIaRpGOoklE/73sVQz9p6e8m2DP83+O8PDLwh16NFqpD745Ds
         95hs1j8qnpIJFvZbuDLL106PrmmLhGXsy2hjw/4dsgGywfO+iK7ZUY6oRoYdjVL/W9QZ
         zAtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788549388; x=1789154188; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZCnu/IOFqlzFGy1VhMJGeYJiUaF7CCozjN+EPzxcJ4o=;
        b=QgvCyWFgyNmROL83YCJLzqwTBjvqoW08p6BDRXpR1/Wh+6eGxue6Y5JE103P3rkSRU
         421GIpzimmQwBi5YOnGSlZTN5RS9/tORuuHXv6MtyticGdqLCG60C3lvy251jwYOZw3y
         UqhaHIh7rOWlGy+JLPP21QWVRXn3ostiASYswG1LajMle4ZVz1qbD0K1cOLCkA2Nefj8
         qVvItzSOEUhB027EIc+dMpEs4Pu87e/faPwBO1l60Q7UoJ66I3nwoWJB3Eg7pX/qyCFf
         yMYOyYCuFftH6n+ATI+4PzUI0J4Z8F19GdLtU4rPDAf+MBk62zPS5SOIvHxGVw5NJDq1
         QhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788549388; x=1789154188;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCnu/IOFqlzFGy1VhMJGeYJiUaF7CCozjN+EPzxcJ4o=;
        b=PuwJ8CWUClKdhgbvJ/vZg181erhXPdCSiJ+3P7FNLaFldqGlnnyuZPyToYGOsYeNs5
         2Ece6Rhxj078BT21nvInrd1LxjVZtA8BVMCMbEladoMXk96+DBubRdfOU203JrCV09ci
         HKn1XZV4THEJdF8PJj1cyg2c1wBCtwPR5lsYjwr8C7DvCr7f7g0cYiCxa9M36kJMUPZV
         d+508Le8UmThKNOdmeyfudr1REG3Z6O1hE3AHnBvQQKoxtor5LQSA57+z9XaUSO37jlz
         B4PFP82UNNVTqqb/8xeQ5pJobWQcia6rftAG6pm9ywoEaaQ//aVuFBJSbFFctcv0QVnr
         6B0g==
X-Gm-Message-State: AFuF++mlsfq/jn/69+S5gIWaQG7DsQZKXbZLj1rUwSu8FWqazFqqhub8
	1L8/nCl37bbTS4fyEA7biN/PsfseWCbsIuQyEl9QpRmXio/JqHucZM24J5D8xzF0KtCK5nai/Ll
	Z5Pl4NsS10Aj2vcz1/8N2Ds+qx+1TOlA=
X-Gm-Gg: AYBFou244d4PN1JkrGVyHlbgqdF0HnodvsXYHnAdtpBmtIiaLXPiIu/FZCIvgByKUey
	g/WqAZsSsuh9vv9PlzTIK+X1AKsxz9K5ZsSZH9BAQXOXSimpLA4KTOwz3veEk6rpbqDj+oUEF6L
	0CR+IS45wltE/U3KGuW1GcvQEdnbS9QuUU9eclrrGPr+IxF1RvVup99K/0D5gEhgxts1ZsR+Wxf
	0X9V8j7jNIQP9tmcmieNuyax94xMwHL+yoxO5ClUDxM55dRPeWkv0/QSIsfGdtNwzGfamsPS6ON
	umoXPxAX/RTFOT+nY4Me638/0Sc7Owg68GYIuaniXq9dsYc6EGWih4ZCWdn/lC762aADcrtMslz
	qboFSZwb20eMu/1grvfY9/KMjbMoMaXNgsEUlcbDyeWAAtpX7Kkxg+3aLmGMaO/eaC8KSytrk5x
	R4/bNLvJ4BdwXXWy16/cfpZ08ifmw0hClfNsNjA8z0yGwSQgTgZt4mTmY=
X-Received: by 2002:a05:6402:3719:b0:6a6:32f5:556f with SMTP id
 4fb4d7f45d1cf-6a7e8e92ad8mr3257058a12.17.1788549387316; Fri, 04 Sep 2026
 12:16:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260815190724.16943-1-rosenp@gmail.com> <12f4b21bb334a49c88bf28428b92589adecfa53a.camel@sipsolutions.net>
In-Reply-To: <12f4b21bb334a49c88bf28428b92589adecfa53a.camel@sipsolutions.net>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 4 Sep 2026 12:16:15 -0700
X-Gm-Features: AcwNN1Uebinon_dT-DPRW-qSB2zh1md1DuwOs37F8oXGrEfMC9-efp4_3gEtAIk
Message-ID: <CAKxU2N9ZPRSotiPhayrQFyzbf=sPcU7X3o6ozRECOibhCj_kbA@mail.gmail.com>
Subject: Re: [PATCHv2 wireless] mac80211: stop tpt LED trigger timer before
 freeing trigger
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, 
	"John W. Linville" <linville@tuxdriver.com>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 4, 2026 at 12:41=E2=80=AFAM Johannes Berg <johannes@sipsolution=
s.net> wrote:
>
> On Sat, 2026-08-15 at 12:07 -0700, Rosen Penev wrote:
> > On a hot unplug, the device is torn down
> > through ieee80211_unregister_hw() without ever going through
> > ieee80211_do_stop(), so the timer is never stopped.
>
> I don't buy this.
>
> Also, missed wifi: prefix.
>
> Please don't just feed me LLM garbage. Do you have a crash reported on
> this?
Not formally no. However I am able to reliably panic the kernel. After
this patch I can't.

Some output:

[20004.982362] Call Trace:
[20004.982365]  <IRQ>
[20004.982369]  led_trigger_blink+0x55/0x90
[20004.982375]  ? __pfx_tpt_trig_timer+0x10/0x10 [mac80211
9e1764ff5588e2fa1476cc1f40fb40aa15fcf740]
[20004.982444]  ? __pfx_tpt_trig_timer+0x10/0x10 [mac80211
9e1764ff5588e2fa1476cc1f40fb40aa15fcf740]
[20004.982500]  call_timer_fn+0x2a/0x130
[20004.982505]  __run_timers+0x27c/0x340
[20004.982511]  run_timer_softirq+0x86/0xf0
[20004.982513]  ? irqtime_account_irq+0x30/0xc0
[20004.982519]  handle_softirqs+0xe3/0x2b0
[20004.982523]  ? srso_alias_return_thunk+0x5/0xfbef5
[20004.982528]  __irq_exit_rcu+0xb0/0x100
[20004.982530]  sysvec_apic_timer_interrupt+0x71/0x90
[20004.982535]  </IRQ>
[20004.982536]  <TASK>

I can do so with a USB wifi adapter using the rt2x00 driver but not
the mt76 driver. I kept pointing the LLM at rt2x00 but it always
determined rt2x00 to be fine and the issue being here.
>
> johannes
