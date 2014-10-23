Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36007 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbaJWUQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 16:16:31 -0400
Received: by mail-wg0-f47.google.com with SMTP id x13so1918073wgg.6
        for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 13:16:30 -0700 (PDT)
Message-ID: <5449621C.3070400@gmail.com> (sfid-20141023_221635_131939_36C13D35)
Date: Thu, 23 Oct 2014 23:16:28 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?TGF1cmVuyJtpdSBOaWNvbGE=?= <lnicola@dend.ro>
CC: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi: Reason 7 periodic disconnect
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com> <54463CE9.3060400@gmail.com> <1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com> <CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com> <1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com> <CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com> <1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com> <CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com> <1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com> <CANUX_P2pJYNhLEMw=iQVe-CSbxqRDqOXL_gUZXxwpmAj2qj=FA@mail.gmail.com> <1414085934.228950.182543717.6FA0F16D@webmail.messagingengine.com> <CANUX_P0nK9AQEzYGfGFKEU_vVJ9fwOPmjGTCL--zmk+J4uCz4Q@mail.gmail.com> <1414093367.254547.182592325.0C3991E4@webmail.messagingengine.com> <CANUX_P3sTY45ozSL6Rj0PRYgo9aPACdp97HV1SQna3AW5V75xw@mail.gmail.com> <1414094840.260168.182602541.16435971@webmail.messagingengine.com>
In-Reply-To: <1414094840.260168.182602541.16435971@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> https://bpaste.net/show/5cc48256d952
> 
> On Thu, Oct 23, 2014, at 22:55, Emmanuel Grumbach wrote:
>> On Thu, Oct 23, 2014 at 10:42 PM, Laurențiu Nicola <lnicola@dend.ro>
>> wrote:
>>> Doesn't seem to help https://bpaste.net/show/68e1a6b33689.
>>
>> ok - let me re-add the logs...
>>
>>

This makes no sense to me.
We do talk to the AP since we get frames Acked...

Can you please apply this on top of what you have?

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2de8870..f3b1e62 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1991,15 +1991,16 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
        if (ieee80211_is_nullfunc(hdr->frame_control) &&
            sdata->u.mgd.probe_send_count > 0) {
                if (ack)
-                       ieee80211_sta_reset_conn_monitor(sdata);
+               //      ieee80211_sta_reset_conn_monitor(sdata);
+               ;
                else
                        sdata->u.mgd.nullfunc_failed = true;
                ieee80211_queue_work(&sdata->local->hw, &sdata->work);
                return;
        }
 
-       if (ack)
-               ieee80211_sta_reset_conn_monitor(sdata);
+//     if (ack)
+//             ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)


Thanks.
