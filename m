Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:33467 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXB0SwY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 13:52:24 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HM7PT-0007UC-VW
	for linux-wireless@vger.kernel.org; Tue, 27 Feb 2007 13:50:48 -0500
Subject: Re: Patch to allow specification of interface name prefix
From: Pavel Roskin <proski@gnu.org>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45E4769E.2040102@candelatech.com>
References: <510326.55988.qm@web50211.mail.yahoo.com>
	 <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	 <45E112F7.9090908@lwfinger.net>	<20070226150241.1b5b63b2@freekitty>
	 <20070227111644.784600be@logostar.upir.cz>
	 <20070227094108.11f4844f@freekitty>  <45E4769E.2040102@candelatech.com>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 13:52:21 -0500
Message-Id: <1172602341.3291.8.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-27 at 10:21 -0800, Ben Greear wrote:

> Regardless of the name, it would be nice to have some quick way to
> determine
> if a network device is wireless or not.  This could be an IOCTL, something
> in /proc/ or similar.  Even if you name them to be wlanX by default, folks
> can rename them, so applications that care about the type of the network
> device can't key off of names reliably...

iwconfig can do it using ioctl.  Shell scripts can do it using
"wireless" directory in sysfs:

for i in /sys/class/net/*; do
  if test -d $i/wireless; then
    echo `basename $i`
  fi
done

-- 
Regards,
Pavel Roskin

