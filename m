Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:43819 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566Ab0BBEZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 23:25:31 -0500
Message-ID: <4B67A937.70406@erley.org>
Date: Mon, 01 Feb 2010 23:25:27 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Witold Sowa <witold.sowa@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Till Kamppeter <till.kamppeter@gmail.com>,
	Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	lsb-discuss@lists.linux-foundation.org
Subject: Re: Linux wireless GSoC 2010 project ideas
References: <43e72e891001281338u5f05307ble5360c3dac6ab9a2@mail.gmail.com> <4B65F024.3080505@gmail.com> <1264972854.3597.17.camel@johannes.local> <43e72e891002011001l4e914094v33e73209a9da93e8@mail.gmail.com> <1265055284.26421.16.camel@maxim-laptop> <20100201221252.GA30758@emergent.ellipticsemi.com>
In-Reply-To: <20100201221252.GA30758@emergent.ellipticsemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/10 17:12, Nick Bowler wrote:
> On 22:14 Mon 01 Feb     , Maxim Levitsky wrote:
>> 2 - Allow a wireless card to associate to several APs at once (if they
>> share the frequency). 
>> Implement this at least for ath5/9k. Madwifi had that feature. Maybe
>> ath9k has. If it has that feature, test it.
> 
> I haven't actually tried this particular case, but this is ostensibly
> already supported by mac80211: iw allows you to create several wireless
> interfaces that share a phy, which can then be configured into different
> modes (I've used station + monitor successfully in the past).
> 
With ath9k I have used:

AP + MP
AP + STA
AP + AP (Open and WPA2)

using both the debug interface to ath9k's internal multi-vif support 
(never tested MP with ath9k multi-vif) and mac80211.  I know that 
if you use the ath9k internal method, you can operate on multiple 
channels at a sacrifice to throughput.  I have not tested if mac80211
supports multiple channels.

It's as easy as:

AP+MP and AP+STA:
Start Hostapd
Create interface with iw
use second interface.

AP+AP
Configure hostapd for multiple bss
start hostapd

Pat Erley
