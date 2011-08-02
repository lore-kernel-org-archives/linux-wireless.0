Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34915 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1HBKyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 06:54:08 -0400
Received: by fxh19 with SMTP id 19so5502095fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 03:54:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312280832-27675-1-git-send-email-anarsoul@gmail.com>
References: <201108021312.23153.anarsoul@gmail.com>
	<1312280832-27675-1-git-send-email-anarsoul@gmail.com>
Date: Tue, 2 Aug 2011 11:54:07 +0100
Message-ID: <CAGq3pz4bQ_2eQbVye==3Xqq3gK4PV6+JJXoHX0TXz=Y7kWC0wQ@mail.gmail.com> (sfid-20110802_125430_963045_F3E5CAED)
Subject: Re: [PATCH 1/2] libertas: add ability to power off card on suspend
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2011 11:27, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> Could be usefull if it's not possible to keep power on the card
> when host goes into suspend.

If it's not possible to keep power during suspend, then I don't see
why you need to explicitly turn it off on the way down.

If power can be maintained, this is going to confuse userspace. If the
network interface is up while you go into suspend, this code would
kick in and power down the device. Then, during resume, it would power
it up again. During this whole time, the network interface has
remained UP, so userspace isn't aware that anything has happened. But,
since the hardware has been powered off and on again, it has lost all
state (association, encryption keys, etc).

The way we handle this in libertas_sdio is that if we don't want the
card powered during suspend, we ask the MMC layer to remove the
device. This causes the remove function to be run, and the interface
disappears. During resume, it gets probed again from scratch, which
then prompts userspace into deciding which network to connect to,
reprogramming keys, etc.

Daniel
