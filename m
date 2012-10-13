Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab2JMH6e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 03:58:34 -0400
Date: Sat, 13 Oct 2012 09:57:29 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/7] rt2800: use BBP_R1 for setting tx
 power
Message-ID: <20121013075728.GA2334@redhat.com> (sfid-20121013_095843_339177_3D0A168A)
References: <1349437455-18754-1-git-send-email-sgruszka@redhat.com>
 <506F0A56.70900@01019freenet.de>
 <20121008091523.GB2478@redhat.com>
 <20121013084720.45682744@dualc.maya.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121013084720.45682744@dualc.maya.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Just saw that I've been using this patchset since Aug 27, 2012 with my
> AP (http://www.wikidevi.com/wiki/Linksys_WMP600N) and
> compat-wireless-3.5-rc5-1 and linux 3.1.10
> 
> iw list and iwconfig are showing always 0 dBm for each channel (2.4 and
> 5 GHz).

For this you need another patch (which should be backported to 3.5 stable too):

commit 5e31fc0815a4e2c72b1b495fe7a0d8f9bfb9e4b4
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Tue Jul 24 08:35:39 2012 +0200

    wireless: reg: restore previous behaviour of chan->max_power calculations


Stanislaw
