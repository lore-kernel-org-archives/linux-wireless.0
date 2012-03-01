Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46468 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2CAE7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 23:59:48 -0500
Received: by vcqp1 with SMTP id p1so175542vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 20:59:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB30B3B09@HASMSX103.ger.corp.intel.com>
References: <CAD2nsn1b0FtbY3MX9MhWxkRwv9KvNvRD7p5jM8GDA=PqS_yiqA@mail.gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB30B3B09@HASMSX103.ger.corp.intel.com>
Date: Thu, 1 Mar 2012 10:29:47 +0530
Message-ID: <CAD2nsn03T=Pq3HdAVb8TzTdgxWCeH8ujuizOciC8R16O9xArgw@mail.gmail.com> (sfid-20120301_055951_375056_C31E650D)
Subject: Re: sleeping function called from invalid context at drivers/net/wireless/iwlwifi/iwl-trans.h:452
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 29, 2012 at 9:25 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> Hi Emmanuel,
>>
>> was debugging some issue in ath9k with UDP bidirectional traffic and
>> then used my inbuilt iwlwifi with bidirectional UDP had this warnings
>>
>> * iwlagn_mac_ampdu_action->iwlagn_tx_agg_start ->  (we take spinlock
>> 'sta_lock' ) -> iwl_trans_tx_agg_alloc (which has might_sleep)
>> * iwlagn_mac_ampdu_action->iwlagn_tx_agg_stop ->  (we take spinlock
>> 'sta_lock' ) -> iwl_trans_tx_agg_disable (which has might_sleep)
>>
> So I was hoping that nobody would hit that one before we push the next batch of patches that includes the fix for this (courtesy of Johannes). In vain.
> Sorry, this is stupid bug: iwl_trans_tx_agg_{alloc,disable} must be atomic...

oh ok , thanks.

-- 
thanks,
shafi
