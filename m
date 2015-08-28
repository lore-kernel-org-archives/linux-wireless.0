Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33508 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbH1MsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 08:48:06 -0400
Received: by wieo17 with SMTP id o17so14589648wie.0
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2015 05:48:04 -0700 (PDT)
From: Sven Eckelmann <sven@open-mesh.com>
To: s prasad <sprasad.kandregula@gmail.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CT firmware and linux kernel patches for OpenWRT( ar71xx - Tp-Link 1750AC )
Date: Fri, 28 Aug 2015 14:48:02 +0200
Message-ID: <2249526.TmOlA3g2Uo@bentobox> (sfid-20150828_144816_190598_028D8BC8)
In-Reply-To: <CAJa-X96RZTQ_=dG+PDxu8x_AeMAXhyKiTc7CrNO=hqhnmYAN-Q@mail.gmail.com>
References: <CAJa-X96RZTQ_=dG+PDxu8x_AeMAXhyKiTc7CrNO=hqhnmYAN-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2015 18:59:51 s prasad wrote:
> Does anybody have patches for CT firmware testing using OpenWRT environment.
> I tried to create patch, however OpenWRT patches supporting only for
> kernel versions 3.18 and 4.1 at the same time CT Kernels supporting
> 3.17_dev, 4.0.4 and 4.2.x. Both are miss matching.

You have to patch mac80211 and not the kernel. I can give you the patchset
I've used with OpenWrt r46435.

You should get it in the next minutes via private mail (I don't want to
send it over the mailing list due to its size). It is basically the
patchset from Ben put on top of compat-wireless 2015-06-22 [1].

You still need extra changes to get VHT working over IBSS (iw will
otherwise only use HT). When you only want to test it then you can
just hardcode a channel + a channel width in iw's ibss.c.

Kind regards,
	Sven


[1] https://dev.cloudtrax.com/git/ath10k-ibss-test.git/shortlog/refs/heads/master-20150824

