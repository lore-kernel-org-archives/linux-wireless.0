Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:56210 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166AbaCEKv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 05:51:26 -0500
Date: Wed, 5 Mar 2014 12:51:23 +0200
From: Jouni Malinen <j@w1.fi>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] mac80211: ignore probe response from adjacent
 channels
Message-ID: <20140305105123.GA32093@w1.fi> (sfid-20140305_115130_211808_A7C91C23)
References: <1393944614-4465-1-git-send-email-emmanuel.grumbach@intel.com>
 <1393944614-4465-2-git-send-email-emmanuel.grumbach@intel.com>
 <20140305090854.GA3544@w1.fi>
 <0BA3FCBA62E2DC44AF3030971E174FB303D786F6@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB303D786F6@HASMSX103.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 05, 2014 at 09:16:44AM +0000, Grumbach, Emmanuel wrote:
> > 
> > On Tue, Mar 04, 2014 at 04:50:14PM +0200, Emmanuel Grumbach wrote:
> > > This logic is already implemented in ieee80211_rx_mgmt_beacon.
> > > The purpose is to ignore probe responses that are received on adjacent
> > > channels. This can happen in 2.4GHz since channels overlap.
> > 
> > Why would this be done? I can understand not updating signal information,
> > but dropping Probe Response frames completely sounds quite undesirable.
> > These can be used to help optimize partial scans and any additional
> > information that can be used without having to change channels sounds
> > helpful to me.

> So I guess you want me to revert the code we currently have in ieee80211_rx_mgmt_beacon ;)

I'm not sure about Beacon frames, but possibly. Anyway, I was more
thinking about use of active scanning on 2.4 GHz band and that would be
more applicable for Probe Response frames.

> Don't know really... If you are associated to an AP and hear its beacons / probe responses on another channel you really have a big problem in your radio?

Is this only for the case of Beacon/Probe Response frames from the AP
with which the device is associated? The commit log seemed to imply that
this is for all Probe Response frames. I have no problems with the Probe
Response from the current AP being ignored from other channels; it is
the case of finding other APs that I'm much more interested in in this
context.

-- 
Jouni Malinen                                            PGP id EFC895FA
