Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:43799 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934750AbZGQQzN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:55:13 -0400
Received: by pzk35 with SMTP id 35so703326pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2009 09:55:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907170952v20677c7fr50204df952228d53@mail.gmail.com>
References: <43e72e890907161810k51e3830bqe3283539f19e2fd2@mail.gmail.com>
	<1247848427.8139.4386.camel@localhost.localdomain> <43e72e890907170952v20677c7fr50204df952228d53@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 17 Jul 2009 09:54:53 -0700
Message-ID: <43e72e890907170954y20375636s7dad8fd972406310@mail.gmail.com>
Subject: Re: Using GeoClue to send a Linux wireless regulatory hint
To: Bastien Nocera <hadess@hadess.net>
Cc: GeoClue <geoclue@lists.freedesktop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>, desrt@desrt.ca,
	Dan Winship <danw@gnome.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	till.kamppeter@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 9:52 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:

> It just reads the country from timezone file, I've pasted the script
> below inline in case you are curious.

Oh and here is the script used by Fedora (thanks to John):

#!/bin/sh

REGDOMAIN=/etc/sysconfig/regdomain
CLOCK=/etc/sysconfig/clock

if [ -f $REGDOMAIN ]
then
        # This should set COUNTRY
        . $REGDOMAIN
        iw reg set $COUNTRY
        exit
fi

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
