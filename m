Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:61634 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYJ1Vye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 17:54:34 -0400
Received: by yw-out-2324.google.com with SMTP id 9so705234ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 14:54:32 -0700 (PDT)
Message-ID: <1ba2fa240810281454v434182f0t5f42ee6cef6c408d@mail.gmail.com> (sfid-20081028_225438_452077_B8D8DC93)
Date: Tue, 28 Oct 2008 23:54:32 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: remove implicit direct scan
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810281353u4b038cf2gb46cb830b278a278@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225214465.3598.27.camel@johannes.berg>
	 <1ba2fa240810281353u4b038cf2gb46cb830b278a278@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 10:53 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, Oct 28, 2008 at 7:21 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> When an undirected scan is requested and iwlwifi is not associated but
>> the user has set an SSID (and maybe was associated with that network at
>> some point) then iwlwifi will assume the user wanted to scan for this
>> SSID which seems wrong. Remove this code.
>>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>> Am I missing something? This seems very strange! What specifies that
>> when an SSID is set on an interface the user wants to scan for that one?
>> The interface might just have been associated previously to that SSID,
>> now disassociated and network manager is asking for a scan to get
>> information about networks to let the user select a new one.
>
> NACK, this is a heuristic that helps connection to configured SSID. It
> doesn't mean that other ssid won't be scanned.
> This code might be revised again when multiple SSID scan will be implemented
> Tomas
>
Okay I've only now have  seen the real reason for this. The SSID
removal from the driver API. It's much better argument for removing
this code anyway have to think how this will be substituted.
Thanks
Tomas

>
>>  drivers/net/wireless/iwlwifi/iwl-scan.c     |    7 -------
>>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    8 --------
>>  2 files changed, 15 deletions(-)
>>
>> --- everything.orig/drivers/net/wireless/iwlwifi/iwl-scan.c     2008-10-28 18:12:02.000000000 +0100
>> +++ everything/drivers/net/wireless/iwlwifi/iwl-scan.c  2008-10-28 18:12:06.000000000 +0100
>> @@ -743,13 +743,6 @@ static void iwl_bg_request_scan(struct w
>>                memcpy(scan->direct_scan[0].ssid,
>>                       priv->direct_ssid, priv->direct_ssid_len);
>>                n_probes++;
>> -       } else if (!iwl_is_associated(priv) && priv->essid_len) {
>> -               IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
>> -                               print_ssid(ssid, priv->essid, priv->essid_len));
>> -               scan->direct_scan[0].id = WLAN_EID_SSID;
>> -               scan->direct_scan[0].len = priv->essid_len;
>> -               memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
>> -               n_probes++;
>>        } else {
>>                IWL_DEBUG_SCAN("Start indirect scan.\n");
>>        }
>> --- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c 2008-10-28 18:12:20.000000000 +0100
>> +++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c      2008-10-28 18:12:27.000000000 +0100
>> @@ -6158,14 +6158,6 @@ static void iwl3945_bg_request_scan(stru
>>                memcpy(scan->direct_scan[0].ssid,
>>                       priv->direct_ssid, priv->direct_ssid_len);
>>                n_probes++;
>> -       } else if (!iwl3945_is_associated(priv) && priv->essid_len) {
>> -               IWL_DEBUG_SCAN
>> -                 ("Kicking off one direct scan for '%s' when not associated\n",
>> -                  print_ssid(ssid, priv->essid, priv->essid_len));
>> -               scan->direct_scan[0].id = WLAN_EID_SSID;
>> -               scan->direct_scan[0].len = priv->essid_len;
>> -               memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
>> -               n_probes++;
>>        } else
>>                IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
>>
>>
>>
>>
>
