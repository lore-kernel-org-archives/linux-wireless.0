Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39870 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbbCaUcd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 16:32:33 -0400
Message-ID: <551B045C.1030400@canonical.com> (sfid-20150331_223240_669944_7811BB1A)
Date: Tue, 31 Mar 2015 13:32:28 -0700
From: Ryan Finnie <ryan.finnie@canonical.com>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: Re: Intel 7265 wireless performance unstable on Linux >= 3.19
References: <551A36A5.2050300@canonical.com>	<CANUX_P0ka+W2x=MtFRyMx6Fts8HQ-+cJxzAO85dkj6GFjQEV4A@mail.gmail.com> <CANUX_P3nsHyGNA6iS=v0=67ALHkUf1LY_os5qpzwNnJyEqpsDA@mail.gmail.com>
In-Reply-To: <CANUX_P3nsHyGNA6iS=v0=67ALHkUf1LY_os5qpzwNnJyEqpsDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 03/31/2015 02:15 AM, Emmanuel Grumbach wrote:
>> Please open a bug on bugzilla.kernel.org and CC
>> ilw@linux.intel.com to the bug. Attach your syslog output as
>> well.

Done: https://bugzilla.kernel.org/show_bug.cgi?id=95901

>> It seems that the supplicant is deauthenticating. What is your
>> supplicant version?

wpasupplicant 2.1-0ubuntu7 from Ubuntu vivid.  From the syslog output,
it appears the wpa_supplicant output is reacting to the kernel event,
with nothing relevant preceding it:

Mar 31 13:15:11 linda systemd[1]: Started Stop ureadahead data collection.
Mar 31 13:15:20 linda kernel: [   72.442153] wlan0: deauthenticating
from 38:2c:4a:5c:7f:e4 by local choice (Reason: 3=DEAUTH_LEAVING)
Mar 31 13:15:20 linda kernel: [   72.457967] cfg80211: Calling CRDA to
update world regulatory domain
Mar 31 13:15:20 linda wpa_supplicant[902]: wlan0:
CTRL-EVENT-DISCONNECTED bssid=38:2c:4a:5c:7f:e4 reason=3
locally_generated=1
Mar 31 13:15:20 linda NetworkManager[815]: <warn> Connection
disconnected (reason -3)

> One idea came through my mind. Can you try this?
> 
> diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c 
> b/drivers/net/wireless/iwlwifi/mvm/mac80211.c index
> 302c8cc..7c12c9f 100644 ---
> a/drivers/net/wireless/iwlwifi/mvm/mac80211.c +++
> b/drivers/net/wireless/iwlwifi/mvm/mac80211.c @@ -525,7 +525,7 @@
> int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm) else 
> hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> 
> -       if (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10) { +       if
> (IWL_UCODE_API(mvm->fw->ucode_ver) >= 10 && false) { 
> hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN; 
> hw->wiphy->max_sched_scan_ssids = PROBE_OPTION_MAX; 
> hw->wiphy->max_match_sets = IWL_SCAN_MAX_PROFILES;

Sorry, it didn't appear to have any effect; DEAUTH_LEAVING would still
occur every ~60 seconds.

RF
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJVGwRQAAoJEH5go6aGro2YthoP/1n2uMoNtnLaXHNXRYMEYqaU
9YZxxIT7dO4uIvjEbSvXzLRuMCfTPrYoP8VbI93XE2/l2qtC/Jy2epV7fxxoEiLy
jky+GYfQQ6Gu2bhMxk8IvES6yCyePUKHP0nXFHxZt0nszrN+39KjbFkYFdR/GAhL
geNPTgnWRsIaJgmNCl9UyyNV/Q93mh/NcKFdeLk0+uapNDPIX/MoKoobUe4Ym31Z
Rv03ZHC5gkxNvNZaYhf89H+2n6+sO3ajs2H9UmDdlSPpRSqsMFQAbCzsjGvTu1td
MJmATaEzLZita3/btlw0ewHfxFpqzyP/p68iwZnVmfjf30SFMqKfRYf/tch/Wirv
N1iWyGD9CaiGKoIIG067bYlr7Zb5XfJDDZe9Uvy49w1GL4O50+ygvqTk5ksgsanf
HFjI3qnOJpv7NWBLU4BKf/ceaIpxoA6AMlvnOFPmdZtFiUY/e+FATR2s9TKAEJNF
MhGBAQkZkLtrjGEZdeT2FhGXpuJroFjNeMKDmDNIFOfTOxtRdvJonSXR8T7wg3na
D/5oDlNP0GiUpVnLid2xKx1o8+hVXwwPfh2yYSjKGPHOCuL/xhr+6oiTyR0O6ush
B3MODlCrCFWmhZtYjxg5l/ln+gvA2ylG3pBURKQMpnn3qb0VbFSRmSwTzzFO7FR2
ceQoLg3b5SCm0i7nvH5O
=lZco
-----END PGP SIGNATURE-----
