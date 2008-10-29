Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:51038 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYJ2O4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 10:56:34 -0400
Received: by rv-out-0506.google.com with SMTP id k40so32092rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 07:56:31 -0700 (PDT)
Message-ID: <b6c5339f0810290756r546f1684m26e2b0d652aa093c@mail.gmail.com> (sfid-20081029_155639_789891_E012922B)
Date: Wed, 29 Oct 2008 10:56:31 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: update keycache to support TKIP handling
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0810290742j2c94e047u8548dfe2bdcde058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225283457-24417-3-git-send-email-me@bobcopeland.com>
	 <40f31dec0810290742j2c94e047u8548dfe2bdcde058@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 10:42 AM, Nick Kossifidis <mickflemm@gmail.com> wrote:
>> diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
>> index 69755fc..037e36d 100644
>> --- a/drivers/net/wireless/ath5k/reg.h
>> +++ b/drivers/net/wireless/ath5k/reg.h
>> @@ -1811,6 +1811,7 @@
>>  #define AR5K_KEYTABLE_ANTENNA          0x00000008      /* [5212+] */
>>  #define AR5K_KEYTABLE_MAC0(_n)         AR5K_KEYTABLE_OFF(_n, 6)
>>  #define AR5K_KEYTABLE_MAC1(_n)         AR5K_KEYTABLE_OFF(_n, 7)
>> +#define AR5K_KEYTABLE_MIC_OFFSET       64
>>  #define AR5K_KEYTABLE_VALID            0x00008000
>>
>>  /* If key type is TKIP and MIC is enabled
>
> Just below...
>
> /* If key type is TKIP and MIC is enabled
>  * MIC key goes in offset entry + 64 */
> #define AR5K_KEYTABLE_MIC_OFFSET        64

Oh, right.  OK, I'll respin this patch without KEYTABLE_MIC_OFFSET and
fix up the reset_key.  Let me know if you see anything else.

-- 
Bob Copeland %% www.bobcopeland.com
