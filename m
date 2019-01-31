Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E12C282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C7F2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 15:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548948799;
	bh=zxoOimWcZtD3MCcVtP3uZ8IJ39VpA/kiZsz5/D8qJ6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=G1G/vro/URfqZS3zsK/O0+rvG/GMzqzNHhJGTSkDyhEJCOEkJXJ/utaLKqvYPqGUX
	 tT5V3SoSc9Mk1ysgevrwBo4tRfRIuGLeYEW8N7TH6k0dl6BFDRcCQuOgCHuD8FWYoK
	 S0ggRIa6Bv06NA/BdTQo3mvh+C1X8Bt2Jz88h5UI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbfAaPdO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:33:14 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42005 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfAaPdN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 10:33:13 -0500
Received: by mail-lj1-f193.google.com with SMTP id l15-v6so3006990lja.9;
        Thu, 31 Jan 2019 07:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kyyDI6FuXbBYrd75ayury4IZgfD/Uq3i12i/fWlvOjM=;
        b=I25UGMXfBTueOiLHgIbQRPPvHNqTBmI+xUjQMncItVnjZOFlVTTY120fPDzU1K+c4I
         jqrrizzrzLW47XXzVySBubNXzpKnINCtYjwPvj5e9OSk+ukaaPjZRO5OJmd1rC/hU+iL
         gQbSxKbQiMviYerwWFBH62agdF9ddDLezj4R71W1I/4rP1tpbsr2ZPJCHqKVAc2S6v3r
         VWrQO5Jk9+MbLQLbaVbt+ObmnlkJTku4+jxGHXJZhQFeIOzqClgQmSFmZpFOWBMq+Yia
         JbxiE1RtoxPo0LVuOojKgM99FGKhUn4uywLlIPeuVoJ2VoGbiyg8sslg58b/N+T7cVLz
         BKFg==
X-Gm-Message-State: AJcUukezlE3t+CdFbtMfqsCNimQ5VLg/cLFFh/KsCCg4rCWZQ/E3Wcq2
        BI8ixLJ46skwtmG2Ot7NAWo=
X-Google-Smtp-Source: ALg8bN5MXqRIR3tCGLT6l3mUssY1qvs7A+NUu0jTPe/eW9Q45a5pYTH1Csr6dQ6dQyLAAG6U167EhA==
X-Received: by 2002:a2e:2d11:: with SMTP id t17-v6mr28633044ljt.159.1548948790426;
        Thu, 31 Jan 2019 07:33:10 -0800 (PST)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id q67sm903018lfe.19.2019.01.31.07.33.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Jan 2019 07:33:09 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1gpEKw-0007Qn-TM; Thu, 31 Jan 2019 16:33:06 +0100
Date:   Thu, 31 Jan 2019 16:33:06 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hovold <johan@kernel.org>, shuah <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        chris@the-brannons.com, devel@driverdev.osuosl.org,
        Rob Herring <robh@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.com>, santhameena13@gmail.com,
        kirk@reisers.ca, Johan Hedberg <johan.hedberg@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, samuel.thibault@ens-lyon.org,
        m.maya.nakamura@gmail.com, zhongjiang@huawei.com,
        Greg KH <gregkh@linuxfoundation.org>,
        speakup@linux-speakup.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        nishka.dasgupta_ug18@ashoka.edu.in,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] tty: Fix WARNING in tty_set_termios
Message-ID: <20190131153306.GT3691@localhost>
References: <20190125232905.21727-1-shuah@kernel.org>
 <20190126041416.GF2217@ZenIV.linux.org.uk>
 <fe4018a7-19e4-cdd1-3095-bbe88a82788e@kernel.org>
 <20190130103227.GR3691@localhost>
 <D0EE5C33-2930-4286-998C-822DD7898B76@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D0EE5C33-2930-4286-998C-822DD7898B76@holtmann.org>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Jan 31, 2019 at 04:18:33PM +0100, Marcel Holtmann wrote:

> > I agree with Al that this change doesn't make much sense. The WARN_ON
> > is there to catch any bugs leading to the termios being changed for a
> > master side pty. Those should bugs should be fixed, and not worked
> > around in order to silence a WARN_ON.
> > 
> > The problem started with 7721383f4199 ("Bluetooth: hci_uart: Support
> > operational speed during setup") which introduced a new way for how
> > tty_set_termios() could end up being called for a master pty.
> > 
> > As Al hinted at, setting these ldiscs for a master pty really makes no
> > sense and perhaps that is what we should prevent unless simply making
> > sure they do not call tty_set_termios() is sufficient for the time
> > being.
> > 
> > Finally, note that serdev never operates on a pty, and that this is only
> > an issue for (the three) line disciplines.
> 
> I think for PTYs we should just fail setting the HCI line discipline.
> Fail early and just move on with life.

Sounds good to me. At least for the pty master. There may be some people
trying to use a bluetooth device connected to a remote serial port (I've
seen descriptions of such setups at least), and maybe we need not prevent
that.

Johan
