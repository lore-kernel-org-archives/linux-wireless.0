Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:45051 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZG3RpX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 13:45:23 -0400
Subject: Re: [PATCH] mac80211: use beacons for connection monitoring
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248949853.29062.3.camel@johannes.local>
References: <1248903159-17024-1-git-send-email-reinette.chatre@intel.com>
	 <4A70C17B.6090309@candelatech.com>
	 <1248949853.29062.3.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 10:45:23 -0700
Message-Id: <1248975923.1216.1074.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 03:30 -0700, Johannes Berg wrote:
> On Wed, 2009-07-29 at 14:39 -0700, Ben Greear wrote:
> > On 07/29/2009 02:32 PM, Reinette Chatre wrote:
> > > From: Reinette Chatre<reinette.chatre@intel.com>
> > >
> > > The connection monitor currently relies on probe requests paired
> > > with probe responses to ensure that a connection is alive. This is
> > > fragile in some environments where probe responses can get lost.
> > > When we receive beacons we can also consider the connection to be
> > > alive, so cancel connection poll instance when we receive a beacon.
> > 
> > I'm chasing a similar problem while working on virtual STA device
> > support in ath5k.  I was also going to try sending up to 3 polls before
> > giving up on the connection.  Does that seems like a valid thing to do?
> 
> That seems somewhat better, yeah.
> 
> I suspect the real cause of the issue is something else though, like the
> probe request not going out properly or the card being in a kind of
> 'temporary lock-up' state where it's not really doing anything for the
> time being -- I've never had a problem on any other (than iwlwifi)
> hardware.

I captured the exchange when this problem occurs using a third system.
The card does indeed try several times to send a probe request and they
are making it out over the air. The AP never responds. 

Is there perhaps anything in this exchange that can help us understand
what is going on?

No.     Time        Source                Destination           Protocol Info
 163883 401.891153  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=980, FN=0, Flags=........, SSID="XXX"
 163885 401.891482  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.11 Probe Response, SN=3557, FN=0, Flags=........, BI=100, SSID="XXX"
 165523 404.884405  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=981, FN=0, Flags=........, SSID="XXX"
 165525 404.885265  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.11 Probe Response, SN=3827, FN=0, Flags=....R..., BI=100, SSID="XXX"
 166981 407.884161  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=982, FN=0, Flags=........, SSID="XXX"
 166983 407.884555  00:14:f2:XX:XX:XX     00:16:ea:XX:XX:XX     IEEE 802.11 Probe Response, SN=4034, FN=0, Flags=........, BI=100, SSID="XXX"
 168133 410.884167  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=........, SSID="XXX"
 168134 410.884430  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168135 410.884643  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168136 410.884904  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168137 410.885073  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168138 410.885330  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168139 410.885580  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168140 410.885769  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168141 410.886618  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168142 410.887087  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168143 410.887308  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168144 410.887532  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Probe Request, SN=983, FN=0, Flags=....R..., SSID="XXX"
 168191 411.084889  00:16:ea:XX:XX:XX     00:14:f2:XX:XX:XX     IEEE 802.11 Deauthentication, SN=984, FN=0, Flags=........


Reinette

