Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58300 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1HBUc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 16:32:29 -0400
Received: by fxh19 with SMTP id 19so164160fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 13:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108022309.07783.anarsoul@gmail.com>
References: <201108021312.23153.anarsoul@gmail.com>
	<1312280832-27675-1-git-send-email-anarsoul@gmail.com>
	<CAGq3pz4bQ_2eQbVye==3Xqq3gK4PV6+JJXoHX0TXz=Y7kWC0wQ@mail.gmail.com>
	<201108022309.07783.anarsoul@gmail.com>
Date: Tue, 2 Aug 2011 21:32:27 +0100
Message-ID: <CAGq3pz6R=8eRNRME-X9e-S12cWvRq_-xvcjCa7KXyRfE0sJ8gw@mail.gmail.com> (sfid-20110802_223232_949269_F6761BE0)
Subject: Re: [PATCH 1/2] libertas: add ability to power off card on suspend
From: Daniel Drake <dsd@laptop.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: libertas-dev@lists.infradead.org, linville@tuxdriver.com,
	dcbw@redhat.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2011 21:09, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> Because no one puts interface down before suspend?
> I just re-tested - if interface is up - kernel does not put it down before
> suspend, so I got a lot of timeouts and errors on dmesg after resume.

I can't see how this would have been influenced by my work.

Your resume handler should already be fixing up the hardware state so
that it can be operated (regardless of any power saving that might
come into effect), or otherwise your suspend handler should cause the
device to be removed so that it can be reprobed completely during
resume.

Daniel
