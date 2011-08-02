Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1HBWcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 18:32:23 -0400
Received: by fxh19 with SMTP id 19so12050fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 15:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108030012.20241.anarsoul@gmail.com>
References: <201108021312.23153.anarsoul@gmail.com>
	<201108022309.07783.anarsoul@gmail.com>
	<CAGq3pz6R=8eRNRME-X9e-S12cWvRq_-xvcjCa7KXyRfE0sJ8gw@mail.gmail.com>
	<201108030012.20241.anarsoul@gmail.com>
Date: Tue, 2 Aug 2011 23:32:21 +0100
Message-ID: <CAGq3pz7gzgaZU2TfVHy5Q6AdKuob2zavPosgXTJtkovtmWpuow@mail.gmail.com> (sfid-20110803_003226_417361_373BB4FB)
Subject: Re: [PATCH 1/2] libertas: add ability to power off card on suspend
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2011 22:12, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> Now generic libertas driver controls power, not if_spi. So it should be able
> to turn off card before going suspend. Messing with power in if_* and generic
> part does not look like a good idea to me.

But there's no way your approach will bring good results. Userspace
won't see any interface state change, but the entire hardware and
firmware will be fully reset. Things will get very confused.

A lot of the stuff done in stop_iface is not relevant for the suspend
case. e.g. If commands were queued before suspend, they should execute
after resume. stop_iface is designed to run when the userspace-visible
interfaces are brought down - by running it while they are still up,
you will confuse things.

You are battling with a general suspend/resume problem which should be
handled by suspend/resume handlers alone. libertas already has plenty
of experience in this area which you can build upon.

Daniel
