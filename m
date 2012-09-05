Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2200 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589Ab2IEKhr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 06:37:47 -0400
Message-ID: <50472B74.5060104@broadcom.com> (sfid-20120905_123755_909148_560DA8DF)
Date: Wed, 5 Sep 2012 12:37:40 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Stanislaw Gruszka" <sgruszka@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	"Jonathan Nieder" <jrnieder@gmail.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	"Milan Bouchet-Valat" <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-3-git-send-email-arend@broadcom.com>
 <20120905102046.GC2311@redhat.com>
In-Reply-To: <20120905102046.GC2311@redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 12:20 PM, Stanislaw Gruszka wrote:
> On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
>> +	ret = wait_event_timeout(wl->tx_flush_wq,
>> +				 brcms_tx_flush_completed(wl),
>> +				 msecs_to_jiffies(BRCMS_FLUSH_TIMEOUT));
>> +
>> +	ieee80211_wake_queues(hw);
>> +	WARN_ON(!ret);
> Any particular reason why this WARN_ON is after ieee80211_wake_queues() ?
>

The wait has a timeout so the warning indicates flush did not complete 
as in the old implementation. Maybe a WARN_ON_ONCE() would be better, 
but I have not observed the warning yet.

Gr. AvS


