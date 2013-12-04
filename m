Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:51813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932270Ab3LDNHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 08:07:33 -0500
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: 'Dan Carpenter' <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: mac80211: add generic cipher scheme support
Date: Wed, 4 Dec 2013 13:07:29 +0000
Message-ID: <3A934E7FDB083A4683727C7D377065951172F2E5@HASMSX105.ger.corp.intel.com> (sfid-20131204_140745_258084_01EB90C5)
References: <20131203163712.GA1857@elgon.mountain>
In-Reply-To: <20131203163712.GA1857@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>   304                  if (pairwise)
>   305                          key = rcu_dereference(sta->ptk[key_idx]);
>   306                  else if (key_idx < NUM_DEFAULT_KEYS)
>   307                          key = rcu_dereference(sta->gtk[key_idx]);
>
>key_idx is a number between 0 and 5.
>NUM_DEFAULT_KEYS is 4.
>->ptk has 4 elements.
>->gtk has 6 elements.
>
>I looked but I didn't see that "pairwise" implied that key_idx is less than 4.
>These are set in nl80211_get_key().

Hi Dan,

1. ptk - I think you are right here - need to verify that key_idx doesn't exceed sta->ptk array boundaries. I'll prepare the fix
2. gtk - frankly I'm not sure about key_idx < NUM_DEFAULT_KEYS. I understand why it's here: not to return management keys, but I don't see a reason why not to do it... In any case I'll prepare the fix for this case too

Max
