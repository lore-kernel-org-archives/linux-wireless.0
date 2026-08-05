Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0CB3DAADE
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 08:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785919403; cv=pass; b=ah+G7bhrmjDtMURjMDFaaaJuvnT5pyVjUG9ZdFU7xhWqvK9w9vWI5VBXbIJUxpiMnv96sSbvcnZ3arXjEU9HPTGdwf21TNjIURYSQ/Ln9XXz/aegSncw+YeceH+z/yP9bKWxVbcGsUMcRHeYVTlJPsHG6SUXvxm1m+dv4uj31zU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785919403; c=relaxed/simple;
	bh=p4AVXEhnitjSEauNc1JbenFziXQ0HgPuZ1/Ak8zfLMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SafPrEOD5I4w4Hbno0QsjMj0VwmBnkZOrIsIDaPFNTXdiyH54uTFwhtE64es7egPSuLZMVdFNW7J1NivXZ7Hy3r2rG+uMW2I6IHD2wXo/7WTFVKtCTC8Ix8BMFjzxK2Crsf2mYQnT5X4R/yx6Jvu36awTYC/o+7j4i6E9EVCsxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=P58m03jI; arc=pass smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="P58m03jI"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso576628a12.0
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2026 01:43:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785919401; cv=none;
        d=google.com; s=arc-20260327;
        b=P8WxnniUcBRHb6lvxbYc5XtU1zQIeod9xv8p2wGFG+zO8tpMgwNBY7va9oYOFuJo/e
         i9fQxmRoYEEd4djmQklDo6qAMoa56I1/T+pBK4rpXoQaH4yjmeUkJee+QPDaB0Dg3ObB
         9yVnYp8mecpPRJU7NaFyugeQbS87FXMhQuhVaEyuIYDE4ev7KzuPjmYldWEyMT0Mlfib
         yL3VIK9/kVS8rIhlMWS+tRLxkDXif9DLKDlumNbaf2xD3Jr0I8PW58cejn6U0g7VT6rp
         kHjI276ahD6GXxZnLzrIpLtqzJQ4kuNkzibBJFSv+RT64v5lxnkuTnV1EiXgjK4I2ECP
         Dlew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MTqkCe18aPA1Av2wWwkCK9WAyRni34+D+T0IQXzzgxg=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=TJ2GQOe21Tn1rXvB4wbMl7LiKYe8a6IMd+Er5FRQeFNnfNbJMZCGq8B3bxHjBpTB4M
         ebMfd/Yi1R3dSGrBWbUGdtZja7vw5dLMtOseWbu2HAoYgSy14hNdquoJEX/dW0KcWmZo
         /R3YC68pV6I6vDvuAngHIqlJ+hvZog6GdHkZt2vUE9Zp4sN1N+xsYYvYRoBE9ARlXTUn
         fvez8XZGPxiVfGTG29N4SuMSXOXzJ1cpdUhyYT276Y4LL2iy4AuqHH4iCi0eiuQAAgOA
         NKUiOKgRP8Vi4kxUOmWm5MuUMnQjWUzQ6+c97Ko8sYQmObYJHse6yJ2SBXHaXiGAIMSJ
         fyNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1785919401; x=1786524201; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MTqkCe18aPA1Av2wWwkCK9WAyRni34+D+T0IQXzzgxg=;
        b=P58m03jI7Pwi8hYAGB0ymMLOSMwR6G6QDt7DXBWZ8HQNpkYk4Zhg8zOjLM52LgSa68
         RrJHxo8TimIhdAJ546pRDoQXxcGLYM+uXNxomFNL5LMLveWdLlmz2UWAP60vqZ1vBsd6
         exZcSQANbhX85QBkfJtbiH4SL2SAQmtHfLr/Gl3bgsELSwJfWSlq6UFZrCN2BmLGCq0b
         6Jx4yJ/GdDHacqd2aSZiN9FPIyWtcIBNubzWkLKN2w9DuaNh7qu9EVzhW467GxnGYc1n
         SNthe7wlXC5NwnMvMhF9aIU+5DKcShIuqS1ed8wjxQQiwTEqyM0pLwQpbbZbjnqZkKlX
         +C0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785919401; x=1786524201;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MTqkCe18aPA1Av2wWwkCK9WAyRni34+D+T0IQXzzgxg=;
        b=PHhEat2kF7QohHaQHxOF7JxjhmGNW/ddMf1NuSbynBEiU1HNb1NhXOKSZn4w0m0NL6
         SLf3fJDnRFo20KF4rnAWJdqNBIH5x00ihtPMaYG5oPW11BBlYYz04u1FZTmcBWykVVE3
         L6iIz9mOrqhDAbBlIixXC9wP62kXSEppCc17GXiMFgB7pVZ516oky+Y0tf06VagMolsr
         cMpkU6D9XR+7WdVh7dY8XvVeCIUEungS6/UAIOftaw2aja5mDONxbB7bbvpWw6ZGdYGm
         dQb6d2IWwZ7AqEqHaxA555cwL5C+e68pC0pL4+yTrLTzNJxXnU0bwaOk0GgsH8i5Ssf1
         Q8vg==
X-Gm-Message-State: AOJu0YwvNaFEkANultsHJ3rEhHfSkzl/Oes1CLQVJCJNpZtrC0RqFYHf
	WJ9UVTOnfeVp3PPIjgWGZWlTuJzxPHYvr8fdlX0GvardGyN58TJeMRxuLHixfBog1U8dfx+0ZBu
	BiuvUmtIn6Qf83W1gn6OzmxAB1Q7ekp3GPzax
X-Gm-Gg: AR+sD13KdO0g3V5zh31DIAWhi3Ff0KSK+l6TEhNIbU9mtY1K1/u2I+PrStbnpcl0p3F
	SaD4xV1gy4Tq4MsgljIUAbBb+DaPUPFEOphv+YJKzX4jb2kDEQOoG8kvxBhE01jr10tjNdgpE1e
	8l1UlIS/JZ6c4JJ2WRWGXMrZyQscvfOQ5BdgYYJejalol/fI8p6gkWa03GsG9blHqZ3eGN9bHPH
	WCVErSOiDaqdllwmpXeb3UHRSqHtVvODOhIFI5Y63zBvpygjomqSgvB9VKRPAhrqYNLEguInnJY
	jgTqMlGud38IVkUbxqZsnqcqRWFFvyitH6vJJ3Or4C/mQOBRu8TwmB0vtj4rYlYACfOkhz9b2vn
	3B5+cJNLwMUQHJ7JSucby5543Q+SwU3Ka3AnRWOdHSy4=
X-Received: by 2002:a05:6a21:139a:b0:3bf:82c5:ed13 with SMTP id
 adf61e73a8af0-3cb860269a0mr6407770637.38.1785919401200; Wed, 05 Aug 2026
 01:43:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com> <013f7d3cf223417c94df41a2a45fa540@realtek.com>
In-Reply-To: <013f7d3cf223417c94df41a2a45fa540@realtek.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Wed, 5 Aug 2026 10:43:08 +0200
X-Gm-Features: AUfX_myY-xASXTL6D1cScwquLe3Oc7VlGWQGh47F5cBM-RGHKVcAQby8-IyH6LU
Message-ID: <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ok, I'll try 6.6.9-arch1-1 for longer to see if I encounter the SER error.

I don't quite understand what you mean with:
> Therefore, if the infrequent SER doesn't bother your daily work, they suggest to just keep it as was.

Do you mean I should keep using the new kernels and ignore the error?
The disconnects aren't the end of the world, but they are annoying and
I was hoping I could help you improve the driver to fix the problem.
So I would like to continue, not just for myself, but to help improve
this for others too. I have an off the shelf prebuilt PC
(https://psref.lenovo.com/Detail/Legion/Lenovo_Legion_T5_26AMR5?M=90RC00UUGE),
I only added a second SSD, so I am sure I am not the only one with
this issue.

> we can bisect the commits in detail.
> I need your help to build and test driver ko.
> The second way is to debug on the latest kernel and apply debug patch to dump more detail needed by internal experts.

I have never built drivers before, and I don't have a lot of
experience with C, but I am a developer, so we can try that. I am
ready to try both options.

Something else I was wondering: In the error logs I see this message:
> firmware failed to ack for leaving ps mode

I am guessing ps mode is power saving mode, which is weird, because
the error happens during zoom calls and remote desktop sessions, which
use the connection constantly. So I would not expect the Wifi-Card to
go into power save mode here.
I read on https://wiki.archlinux.org/title/Network_configuration/Wireless
that in quite a few cases they suggest disabling power save.
I checked and power save seems to be enabled on my system:
$ iw dev wlan0 get power_save
Power save: on

Should I try to disable it? Would that give you any new information?

The arch wiki also contains a chapter specific to rtw89:
https://wiki.archlinux.org/title/Network_configuration/Wireless#RTW89
They suggest disabling ASPM-related features using the config below.
/etc/modprobe.d/70-rtw89.conf
  options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss=y
  options rtw89_core disable_ps_mode=y

See also:
https://github.com/lwfinger/rtw89#option-configuration
https://github.com/lwfinger/rtw89/issues/275#issuecomment-1784155449

However this sounds like it affects notebooks, whereas I have a desktop PC.

Should I try this? Would that give you any new information?
