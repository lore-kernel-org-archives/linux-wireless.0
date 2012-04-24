Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:49716 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab2DXKDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 06:03:30 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SMcam-0001Uc-G4
	for linux-wireless@vger.kernel.org; Tue, 24 Apr 2012 12:03:28 +0200
Received: from localhost ([::1]:52002 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SMcam-00058u-CK
	for linux-wireless@vger.kernel.org; Tue, 24 Apr 2012 12:03:28 +0200
Received: from [195.4.92.23] (port=38738 helo=13.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SMcXw-0004Vz-GD
	for linux-wireless@vger.kernel.org; Tue, 24 Apr 2012 12:00:32 +0200
Received: from [2002:4fde:13fa:2:5054:ff:feb8:40bd] (port=54314 helo=mail.maya.org)
	by 13.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SMcXw-0000jO-1X
	for linux-wireless@vger.kernel.org; Tue, 24 Apr 2012 12:00:32 +0200
Message-ID: <4F9679AB.6010103@01019freenet.de> (sfid-20120424_120333_501470_68344270)
Date: Tue, 24 Apr 2012 12:00:11 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Andrew Chant <andrew.chant@gmail.com>
CC: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: AP mode my ath9k broke between 3.3 and 3.4-rc2
References: <CANugF37WSOdHODRXOb6nnBCh5HMTTUqf0VpyPuTDdNK80-LkAQ@mail.gmail.com> <CANugF37wdS3=u7grT3H6WAJM=XxTukZoWdj70SXLL8k_6t1b6A@mail.gmail.com>
In-Reply-To: <CANugF37wdS3=u7grT3H6WAJM=XxTukZoWdj70SXLL8k_6t1b6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrew Chant wrote:
> 3.4-rc4 doesn't work either.
> If I revert the patch on 3.4-rc4, the Intel card is able to associate again.
> -Andrew
> 
> On Tue, Apr 24, 2012 at 12:11 AM, Andrew Chant <andrew.chant@gmail.com> wrote:
>> Hello,
>>  my Atheros AR9300 PCIe card (168c:0030) stopped working as an AP on
>> the 5GHz band between 3.3 and 3.4-rc2.
>> After 14 git bisects, I believe I have narrowed it down to the following patch:
>>
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=293702a3fb75832613e2af097bdc3ac8ef775b33
>>
>> mac80211: use common radiotap code for cooked monitors

Same problem here with ar9285 / 2.4GHz / eap-tls / 802.11n / hostapd
0.7.3 / compat-wireless-3.4-rc3-1.tar.bz2

Removing "mac80211: use common radiotap code for cooked monitors" solves
the problem here, too.

Using rt2860 as AP seems not to be a problem.


Regards,
Andreas Hartmann
