Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:37088 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZIPWF5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 18:05:57 -0400
Received: by bwz19 with SMTP id 19so3826656bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 15:05:59 -0700 (PDT)
From: Fabio Coatti <fabio.coatti@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless 5100 AGN
Date: Thu, 17 Sep 2009 00:05:56 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mjg@redhat.com" <mjg@redhat.com>
References: <200909161521.15710.fabio.coatti@gmail.com> <200909161657.44453.fabio.coatti@gmail.com> <1253118619.26521.420.camel@rc-desk>
In-Reply-To: <1253118619.26521.420.camel@rc-desk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200909170005.56145.fabio.coatti@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In data mercoledì 16 settembre 2009 18:30:19, reinette chatre ha scritto:

> On Wed, 2009-09-16 at 07:57 -0700, Fabio Coatti wrote:
> > But the behaviour of wifi sybsystem is still weird, (maybe for some
> > faults on my side). Basically if the laptop starts with wifi enabled
> > (rfkill off) wpa_supplicant can establish a connection, that can be
> > killed by rfkill switch (both wifi and bluetooth seems to be killed). But
> > when I turn off rfkill switch wpa_supplicant is unable to connect again;
> > looking at syslog/dmesg I can see activity in bt stack, but no messages
> > regarding wlan0.
> 
> I think at this point you need to bring the interface back up. When you
> enable rfkill the interface is brought down, the opposite (bringing
> interface up) is not done automatically when you disable rfkill.
> 

Ok, I understand your point. In fact I can bring up the interface using 
"ip link set wlan0 up" 
but this leads me to another question: I fail to see how restart the interface 
automatically when rfkill switch is turned off.
The expected behaviour in this case should be, imho, that wpa_supplicant wakes 
up and restarts the connection.
IIRC netplug doesn't work with wireless connections and this leaves me 
wondering how I can have wireless la to wake up after turning off rfkill 
switch :)
