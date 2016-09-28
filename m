Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:43577 "EHLO
        li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752523AbcI1U67 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 16:58:59 -0400
Date: Wed, 28 Sep 2016 23:58:55 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 6/6] cfg80211: reduce connect key caching struct size
Message-ID: <20160928205855.GA27770@w1.fi> (sfid-20160928_225902_529646_EDADB9F7)
References: <1473777868-32429-1-git-send-email-johannes@sipsolutions.net>
 <1473777868-32429-6-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1473777868-32429-6-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2016 at 04:44:28PM +0200, Johannes Berg wrote:
> After the previous patches, connect keys can only (correctly)
> be used for storing static WEP keys. Therefore, remove all the
> data for dealing with key index 4/5 and reduce the size of the
> key material to the maximum for WEP keys.

> diff --git a/net/wireless/core.h b/net/wireless/core.h

>  struct cfg80211_cached_keys {
> -	struct key_params params[6];
> -	u8 data[6][WLAN_MAX_KEY_LEN];
> -	int def, defmgmt;
> +	struct key_params params[4];
> +	u8 data[4][WLAN_KEY_LEN_WEP104];
> +	int def;
>  };

As noted in our irc discussion, this is not really a good thing to do.
WEXT compat code uses this structure for all ciphers, not just static
WEP keys. BIP configuration can use key index 4-5 and the key lengths
can go up to 32 bytes instead of WLAN_KEY_LEN_WEP104. In other words,
this patch should be dropped or reverted since it causes kernel panics
due to memory corruption when writing beyond this reduced size
structure.

This was found with hwsim tests and after full day of running full test
runs, a compressed form for easy triggering of the issue was found:

hostap/tests/hwsim/vm$ ./vm-run.sh wext_pmf wext_pmf wext_pmf wext_pmf wext_pmf wext_pmf
Starting test run in a virtual machine
./run-all.sh: passing the following args to run-tests.py: wext_pmf wext_pmf wext_pmf wext_pmf wext_pmf wext_pmf 
START wext_pmf 1/6
PASS wext_pmf 7.384815 2016-09-28 20:36:15.644646
START wext_pmf 2/6
qemu-system-x86_64: 9pfs:virtfs_reset: One or more uncluncked fids found during reset
qemu-system-x86_64: 9pfs:virtfs_reset: One or more uncluncked fids found during reset
KERNEL CRASHED!

-- 
Jouni Malinen                                            PGP id EFC895FA
