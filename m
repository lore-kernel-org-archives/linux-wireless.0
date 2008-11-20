Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:36142 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYKTIqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 03:46:47 -0500
Received: by rv-out-0506.google.com with SMTP id k40so360878rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 00:46:46 -0800 (PST)
Message-ID: <1ba2fa240811200046y67f18e48ubc8a2f4a586be627@mail.gmail.com> (sfid-20081120_094652_228090_0B52F836)
Date: Thu, 20 Nov 2008 10:46:46 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 7/7] iwlwifi: prevent double key removal
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1227164164.17336.18.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1227137548-28718-1-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-2-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-3-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-4-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-5-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-6-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-7-git-send-email-reinette.chatre@intel.com>
	 <1227137548-28718-8-git-send-email-reinette.chatre@intel.com>
	 <1227164164.17336.18.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 8:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-19 at 15:32 -0800, Reinette Chatre wrote:
>
>
>> When the key is removed a second time the offset is set to 255 - this index
>> is not valid for the ucode_key_table and corrupts the eeprom pointer (which
>> is 255 bits from ucode_key_table).
>
>> +     if (WARN(priv->stations[sta_id].sta.key.key_offset == WEP_INVALID_OFFSET,
>> +              "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_flags)) {
>> +             spin_unlock_irqrestore(&priv->sta_lock, flags);
>> +             return 0;
>> +     }
>
> So, since _this_ patch has been tested to fix the problem, the WARN_ON
> must be triggering.

It fix the immediate problem of crashing the kernel but not the
problem why the key is removed twice.
I'm analyzing the log I've got from Carlos to figure this out you can
have a look as well.
It should be probably considered as a test patch. The purpose is not
to hide the bug buy fixing a symptom.
I suspect there is some problem in mac80211 is that this is happening
only on suspend/resumes not in regular flow

> What are you doing to address the actual bug that causes it to trigger?

If the flow of double removal of a key is okay from mac80211
perspective we just catch it internally which is always good otherwise
we need to fix also mac80211.
Thanks
Tomas
