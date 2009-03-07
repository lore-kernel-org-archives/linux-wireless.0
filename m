Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32816 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbZCGTa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 14:30:29 -0500
Date: Sat, 7 Mar 2009 14:24:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Chuck Anderson <cra@WPI.EDU>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlagn won't scan 5 GHz band
Message-ID: <20090307192417.GA6648@tuxdriver.com> (sfid-20090307_203033_624156_2A713A41)
References: <20090306230124.GU10097@angus.ind.WPI.EDU>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
In-Reply-To: <20090306230124.GU10097@angus.ind.WPI.EDU>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 06, 2009 at 06:01:24PM -0500, Chuck Anderson wrote:
> Please Cc: me on replies as I'm not subscribed.  Thanks.
> 
> I have a 4965, using kernel-2.6.29-0.197.rc7.fc11.x86_64 (Intel(R) 
> Wireless WiFi Link AGN driver for Linux, 1.3.27kds).  I can connect to 
> 802.11n on 2.4 GHz, but it never finds the 5 GHz cell of the AP.  Is 5 
> GHz 802.11n supported yet?  For that matter, shouldn't I be seeing the 
> 802.11a from my APs?  How do I get this thing to scan the A/N 5 GHz 
> band?

Ah, the joys of Rawhide...

Make sure you have "iw" installed.

	yum install iw

Then you need to specify your regulatory domain:

	iw reg set US # Use ISO/IEC 3166-1 alpha2 as appropriate for you

Does that change things for you?

We are still discussing ways to get this set automatically.  We are
hoping that NetworkManager grows this capability "soon"...  In the
meantime, you might try calling the attached script from /etc/rc.local.

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=set-regdomain

#!/bin/sh

CLOCK=/etc/sysconfig/clock

if [ -f $CLOCK ]
then
	# This should set ZONE
	. $CLOCK
else
	echo "Timezone information not found!  Unable to set regulatory domain."
	exit
fi

if [ -z "$ZONE" ]
then
	echo "Timezone information not set!  Unable to set regulatory domain."
	exit
fi

COOKED_ZONE=$(echo $ZONE | sed -e 's/ /_/')

COUNTRY=$(grep $COOKED_ZONE /usr/share/zoneinfo/zone.tab | awk '{ print $1 }')

if [ -z "$COUNTRY" ]
then
	echo "Could not determine country!  Unable to set regulatory domain."
	exit
fi

iw reg set $COUNTRY

--8t9RHnE3ZwKMSgU+--
