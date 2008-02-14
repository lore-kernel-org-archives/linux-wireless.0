Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16315 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYBNRwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 12:52:33 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: kernel 2.6.25-rc1 and no /dev/rt73usb
Date: Thu, 14 Feb 2008 09:52:07 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003ABC619@orsmsx416.amr.corp.intel.com> (sfid-20080214_175245_916141_B0C9BE15)
In-Reply-To: <20080214135635.GA2981@tuxdriver.com>
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl> <1202952347.29519.5.camel@dv> <BAY101-W1421BB30E73369FE0A2E3DC8250@phx.gbl> <a32f33a40802140149w48a1ee51idf4a7fd0619879f3@mail.gmail.com> <20080214135635.GA2981@tuxdriver.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Ivo Van Doorn" <ivdoorn@gmail.com>
Cc: "Adam Turk" <bofh1234@hotmail.com>,
	"Pavel Roskin" <proski@gnu.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , linux-wireless-owner@vger.kernel.org  wrote:

> On Thu, Feb 14, 2008 at 10:49:34AM +0100, Ivo Van Doorn wrote:
>> Hi,
>> 
>>>  phy0: Failed to initialize wep
>> 
>> I see this message popping up more frequently lately.
>> 
>> Do any of the mac80211 people know when and why mac80211 fails to
>> load the wep module? Is there some dependency missing for mac80211?
> 
> I don't know, but it seems like there must be something like that.
> It might be helpful to post the .config for the failing kernel?

We have also seen that modprobe sometimes do not resolve all the
dependecies. What works when we get this error is to load the following
modules manually before loading the wifi driver.

blkcipher aes arc4 ecb cryptomgr crypto_algapi

Reinette
