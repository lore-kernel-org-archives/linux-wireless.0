Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41231 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2AESG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 13:06:56 -0500
MIME-Version: 1.0
In-Reply-To: <20120105.122004.1170447281304011158.davem@davemloft.net>
References: <1325770673-17309-1-git-send-email-festevam@gmail.com>
	<4F05CBA9.1070602@lwfinger.net>
	<20120105.122004.1170447281304011158.davem@davemloft.net>
Date: Thu, 5 Jan 2012 16:06:54 -0200
Message-ID: <CAOMZO5AuZ_MHW3C1uNK7PyRz=XRHXhn2pvKCwk7iXLDd0YkDOQ@mail.gmail.com> (sfid-20120105_190701_529723_FBAEEB8C)
Subject: Re: [PATCH v2] drivers: net: Fix dependency for EEPROM_93CX6
From: Fabio Estevam <festevam@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Larry.Finger@lwfinger.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, gwingerde@gmail.com,
	linville@tuxdriver.com, fabio.estevam@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 5, 2012 at 3:20 PM, David Miller <davem@davemloft.net> wrote:

> Right, this is definitely the wrong fix, "select" is the right way to
> fix this because no user should have to know the gory details of what
> random odd config variables have to be on already in order to turn on
> support for a device they are interested in.
>
> Fix this right, by using "select MISC_DEVICES"

I have tried selecting MISC_DEVICES in the Kconfig's, but the warning remains.

I agree with Ben's comment: "That seems like a bug, since MISC_DEVICES
doesn't by itself select any
code.  (It's also not a meaningful category and maybe ought not to be an
option at all.)"

Regards,

Fabio Estevam
