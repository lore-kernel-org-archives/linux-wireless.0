Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D54C10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 23:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9316F2133D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 23:25:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KIYpXD/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfDIXZm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 19:25:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34424 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfDIXZm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 19:25:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id o199so271717lfo.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 16:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hTeQkyBFAFa5UWeKrM0CXcNP2qNkdtJLos961vCIaW0=;
        b=KIYpXD/VczN+/cJfeHejKK2rFeUV0gP8R+qEh75jjmTIy0Bsr/0wzeEsE1OyWmUle4
         Sc47mGcgoYIqunkb9YIvCXmOgC5V6Y4YXsjECUyzTKjRzRKuzKi9mIAE8emxb5N7tTpx
         ENcBJIEdtlNTt8SgKCAJY7RuRvaFZo+vgPLmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hTeQkyBFAFa5UWeKrM0CXcNP2qNkdtJLos961vCIaW0=;
        b=lqC7DYGF3MhO/y6SM2WF506ErR3TJqmkPSH6ToIpvugijiWQdUFGlPyTcpLf5/ai1p
         GMQWYhVxdmv4oqqMRvGb1lvGbZ+/BUttLbmBme0lb3wG/hmVpWiaO6UORCBRFuZ2VvQB
         0t9RJDdZc/zWfyClZ6zf+k6/iCket9gNtNTmGdLytHlMhFPsO7ieLldN2I1tewVqJXL5
         Hn1y9MFmm5RTqbQdQnf95YgqY1v+EEjf9/cvVYJP9FaRjchy/vZZISnulmECj/3ZRRjL
         7vnY4CD1JCC+76V/CWBm1izrb2VJ+Yl5djrmJvCX7qk77OrziJ1wJhbRe2hmPUCqtXOg
         Agjw==
X-Gm-Message-State: APjAAAU9kccy7o0q+GQg/ikvcqnxbKRFXywhRK4IRmXrlfhFv0N8HLhO
        V5eWAEOKEbIKTEC3q/B8WHokjFVLjlM=
X-Google-Smtp-Source: APXvYqy7rCRRfA/3p60u5zUd9EyAFscOKJNqRE2kO5wLyAf7x/tNZ8TFb7BL91Okqm+Bc5QTR+U9hg==
X-Received: by 2002:ac2:51aa:: with SMTP id f10mr20764507lfk.82.1554852339870;
        Tue, 09 Apr 2019 16:25:39 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id j27sm6748161lfk.97.2019.04.09.16.25.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 16:25:39 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id u24so254936lfg.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 16:25:39 -0700 (PDT)
X-Received: by 2002:a19:c203:: with SMTP id l3mr20188193lfc.39.1554852338465;
 Tue, 09 Apr 2019 16:25:38 -0700 (PDT)
MIME-Version: 1.0
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
 <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
 <195f3bb0c88c43a6b1ca0ad336f947c0@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWAfB8jjCDW4ggjJ8_YC++CjttJOMOt4s24F3mymvNR9A@mail.gmail.com>
 <02904ba8682441e1a89668c1345cbec9@aptaiexm02f.ap.qualcomm.com>
 <54b4dab1191d41b8b329f3ceb7017626@aptaiexm02f.ap.qualcomm.com>
 <CABvG-CWz0rBCXfF7mX9L62=fmdcYhpOaO5JNLtvSE87o_XJFng@mail.gmail.com> <1fec49e1b6794860a1eff2330bcdea28@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <1fec49e1b6794860a1eff2330bcdea28@aptaiexm02f.ap.qualcomm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 9 Apr 2019 16:25:27 -0700
X-Gmail-Original-Message-ID: <CA+ASDXP1Ftpi93p=Bp2w1rRd3xVtNn_+diwkKTMXbTqK0B3ahA@mail.gmail.com>
Message-ID: <CA+ASDXP1Ftpi93p=Bp2w1rRd3xVtNn_+diwkKTMXbTqK0B3ahA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>,
        Wen Gong <wgong@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Apr 8, 2019 at 10:09 PM Wen Gong <wgong@qti.qualcomm.com> wrote:
> > From: Micha=C5=82 Kazior <kazikcz@gmail.com>
> > To satisfy both I would suggest you either expose ar->state via
> > debugfs and make your test procedure wait for that to get back into ON
> > state before simulating a crash again, or to extend the set of current
> > simulate_fw_crash commands (currently just: soft, hard, assert,
> > hw-restart) to something that allows expressing the intent whether
> > crash-in-crash prevention is intended (your case) or not (my original
> > case).
> >
> > This could be for example something like this:
> >   echo soft wait-ready > simulate_fw_crash
> >
> > The "wait-ready" extra keyword would imply crash-in-crash prevention.
> > This would keep existing tools working (both behavior and syntax) and
> > would allow your test case to be implemented.
> >
> Is it easy to change your existing tools?
> I want to change it to: echo soft skip-ready > simulate_fw_crash
> The "skip-ready" extra keyword would imply crash-in-crash, *not* preventi=
on.
> My test tools is hard to change.

In case you're talking about the test framework we run for ChromeOS
validation, no, it's not hard at all to change. As long as there's a
good reason.

I haven't closely followed this, but judging by the above summary,
it's probably more reasonable for our test framework to only simulate
FW crashes after the driver returns to "ready" (or at least, if we do
crash-in-crash, don't expect the driver to recover?). I expect we can
work with whatever mechanism you implement for that (exposing the
"state", or providing a new simulate_fw_crash mode).

Brian
