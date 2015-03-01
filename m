Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37860 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbbCAWXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 17:23:43 -0500
Received: by wesw55 with SMTP id w55so29964667wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 01 Mar 2015 14:23:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425238304-498-19-git-send-email-emmanuel.grumbach@intel.com>
References: <1425238186.30202.5.camel@egrumbacBox> <1425238304-498-19-git-send-email-emmanuel.grumbach@intel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Mar 2015 09:23:21 +1100
Message-ID: <CAGRGNgXe0v7Xro3RgyeHWMOhMQiNkn7vPhgQM4j6VpNP7-yTrA@mail.gmail.com> (sfid-20150301_232347_376703_DA53FA8A)
Subject: Re: [PATCH 19/31] iwlwifi: mvm: don't iterate interfaces to
 disconnect in net-detect
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Emmanuel,

On Mon, Mar 2, 2015 at 6:31 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> We shouldn't call iwl_mvm_d3_disconnect_iter() on the running
> interfaces when we are woken up due to net-detect, because it doesn't
> make sense.  Additionally, this seems to set the
> IEEE80211_SDATA_DISCONNECT_RESUME flag that will cause a disconnection
> on the next resume (if a normal WoWLAN is used).
>
> To solve this, skip the iteration loop when net-detect is set.
>
> Reported-by: Samuel Tan <samueltan@chromium.org>
> Reviewed-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Shouldn't this be signed off by Luciano too?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
