Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:27490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020AbYARQen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 11:34:43 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 04/12] iwlwifi: document scan command
Date: Fri, 18 Jan 2008 08:34:25 -0800
Message-ID: <4220499A1B034C4FA93B547BA01E1FF001746541@orsmsx413.amr.corp.intel.com> (sfid-20080118_163448_520903_C8749F5C)
In-reply-to: <1200441772.5887.167.camel@johannes.berg>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com> <1200361585-31801-2-git-send-email-reinette.chatre@intel.com> <1200361585-31801-3-git-send-email-reinette.chatre@intel.com> <1200361585-31801-4-git-send-email-reinette.chatre@intel.com> <1200361585-31801-5-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022705_457944_D9860755) <1200441772.5887.167.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Johannes Berg [mailto:johannes@sipsolutions.net] 
> Sent: Tuesday, January 15, 2008 7:03 PM
> To: Chatre, Reinette
> Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; 
> Cahill, Ben M; Zhu, Yi
> Subject: Re: [PATCH 04/12] iwlwifi: document scan command
> 
> 
> > +/**
> > + * struct iwl3945_scan_channel - entry in REPLY_SCAN_CMD channel 
> > +table
> > + *
> > + * One for each channel in the scan list.
> > + * Each channel can independently select:
> > + * 1)  SSID for directed active scans
> > + * 2)  Txpower setting (for rate specified within Tx command)
> > + * 3)  How long to stay on-channel (behavior may be 
> modified by quiet_time,
> > + *     quiet_plcp_th, good_CRC_th)
> 
> This reminds me. How did you arrive at the dwell time? With 
> hostapd running on b43 I've frequently seen the dwell time 
> being too low:
> 
> iwl4965 will transmit a probe request and go to the next 
> channel before hostapd sends the probe response, iwl4965 
> still sees the response, but the b43 card never sees the ACK 
> because it's receiver isn't quite as good as the iwl4965 receiver.

I'm not sure of the history of the dwell time values, but it's an
attempt to balance reliability of scan vs. speed of scan.  The active
dwell times are, of course, more speed-aggressive than the passive ones.
Would you be willing to experiment with your setup, and try some
different values?

-- Ben --

> johannes
> 
