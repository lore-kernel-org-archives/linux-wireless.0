Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45818 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaCUP5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 11:57:10 -0400
Message-ID: <532C6138.7010201@candelatech.com> (sfid-20140321_165715_091042_CC058F0B)
Date: Fri, 21 Mar 2014 08:56:40 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com> <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
In-Reply-To: <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/20/2014 11:33 PM, Michal Kazior wrote:
> On 21 March 2014 01:05,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> Make the request command object the right size so that
>> firmware will not just throw it away.
>> Tested customized and upstream firmware.
> 
> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.

The firmware source I have checks in such a way that sending too
large of a cmd should be fine, only too small of a command packet
causes it to be ignored.

I do not have the 636 firmware to test against.

>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/wmi.h | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
>> index fa1b9e0..4946471 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.h
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
>> @@ -2766,6 +2766,11 @@ enum wmi_stats_id {
>>         WMI_REQUEST_AP_STAT     = 0x02
>>  };
>>
>> +struct wlan_inst_rssi_args {
>> +       __le16 cfg_retry_count;
>> +       __le16 retry_count;
>> +};
>> +
>>  struct wmi_request_stats_cmd {
>>         __le32 stats_id;
>>
>> @@ -2773,6 +2778,12 @@ struct wmi_request_stats_cmd {
>>          * Space to add parameters like
>>          * peer mac addr
>>          */
> 
> You can probably remove the comment now :-)

Ok, I can do that.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

