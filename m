Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:45661 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbZIOXrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:47:24 -0400
Received: by pzk28 with SMTP id 28so3783197pzk.20
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 16:47:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
Date: Tue, 15 Sep 2009 16:41:29 -0700
Message-ID: <45e8e6c40909151641o423cbc70y22033061505661b6@mail.gmail.com>
Subject: Re: [PATCH] libertas: Add auto deep sleep support for
	SD8385/SD8686/SD8688
From: Andrey Yurovsky <andrey@cozybit.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing.  This is not specific to the actual implementation of the
deep sleep commands in your patch but,

On Tue, Sep 15, 2009 at 4:45 PM, Bing Zhao <bzhao@marvell.com> wrote:
> +       Path: /sys/kernel/debug/libertas_wireless/ethX/

Is the sysfs interface really necessary?  It seems like yet another
non-standard configuration option to keep track of.

Deep sleep seems to pretty much "turn off" the wifi card (as far as
the user is concerned) so how about a simpler approach: enter deep
sleep when the interface is brought down (ifconfig wlanN down) and
exit deep sleep when it's brought up.  Do this only when deep sleep is
supported/possible.  Alternately, maybe this belongs as an rfkill
feature?

  -Andrey
