Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:2843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757949AbZIQJQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 05:16:18 -0400
Received: by fg-out-1718.google.com with SMTP id 22so114373fge.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 02:16:21 -0700 (PDT)
From: Fabio Coatti <fabio.coatti@gmail.com>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>
Subject: Re: iwlagn rfkill and 2.6.31 on Intel Corporation PRO/Wireless 5100 AGN
Date: Thu, 17 Sep 2009 11:16:19 +0200
Cc: reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mjg@redhat.com" <mjg@redhat.com>
References: <200909161521.15710.fabio.coatti@gmail.com> <200909170005.56145.fabio.coatti@gmail.com> <3ace41890909161615u64d2878i8ddb52c2ba03ea52@mail.gmail.com>
In-Reply-To: <3ace41890909161615u64d2878i8ddb52c2ba03ea52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909171116.19281.fabio.coatti@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I
> Hmm, I recently looked to the interaction between rfkill and hal, and
> may be able to answer that. The kernel rfkill module also exports its
> state via either /dev/rfkill or sysfs's /sys/class/rfkill (depending
> on kernel version; I think /dev/rfkill is new to
> 2.6.31/wireless-testing/compat-wireless, and not in 2.6.30). hald or
> devicekit (again, depend on distro/kernel version) monitors those, and
> informs NetworkManager via d-bus messaging when the rkfill state
> changes. NetworkManager then if up/down the device and tell
> wpa_supplicant accordingly. So the ifconfig-interface-up is supposed
> to happen automatically, if hald/devicekit works and talk to
> NetworkManager.
> 
> i.e. the waking-up should happen automatically if you have the
> combination of hald/devicekit and networkmanager.
> 
> Does this answer your question?
> 

Indeed; it's a good explanation of what's going on. Now I'll follow each step 
of your descripiton and I'll try to find out where the chain breaks :)


Many thanks for your help.
