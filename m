Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:37572 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbYI1Ttg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 15:49:36 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1205173fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 28 Sep 2008 12:49:34 -0700 (PDT)
Message-ID: <1ba2fa240809281249q23112307n85f7685cb232fc57@mail.gmail.com> (sfid-20080928_214940_358103_707AB2B9)
Date: Sun, 28 Sep 2008 22:49:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Cc: "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com, hmh@hmh.eng.br,
	linux-wireless@vger.kernel.org
In-Reply-To: <200809271334.15190.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com>
	 <200809271012.33908.IvDoorn@gmail.com>
	 <1ba2fa240809270408i1eab50f7lb48739d75deab676@mail.gmail.com>
	 <200809271334.15190.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > See the discussion between Henrique and me
>> >        "[RFC] b43: A patch for control of the radio LED using rfkill"
>> > from last week.

So I read that thread and first conclusion I came to is that the whole
long thread was there due to
fact that you were not able to define rfkill in the same language even
though Henrique spent a lot of time on documentation.
iwlwifi HW is more like b43 has ability for hard and soft killing the
radio physically. So what we define as soft rfkill is actually writing
the register to the HW and that was my intention when I'm talking
about soft rfkill. I don't define rfkill to be singal from input
device.
I guess that  the confusion about connecting hw switch to rfkill line
comes from difference between USB and PCI devices. While Wifi PCI
usually sits in a mini card slots witch defines rfkill line by spec
this is not the case in a USB dongle so this have to delivered around,
this is rather deficiency in USB spec. Of course USB can sit also in
mini card but that's not general case.
Soft rfkill line in PCI devices is here to answer needs such as
txpower off/on so this is not the same think as catching external
event of hw switch and applying rfkill into devices or other tricks
that laptops vendors do to implement it.
When I'm talking about policy this is decision how radio state is
drawn from sort and hw rfkill switches in PCI context.
I have to read some more about your conclusions in the thread so I
won't continue here I hope Emmanuel and I will come to some
implementations soon as we need to close the rfkill bugs in iwlwifi
that comes from fact that mac80211 is not in the game yet. (again
rfkill in register level).

Thanks
Tomas
