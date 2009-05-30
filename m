Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:50178 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754347AbZE3UI4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 16:08:56 -0400
Received: by ewy24 with SMTP id 24so6992428ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 13:08:57 -0700 (PDT)
Message-ID: <4A219250.2050606@gmail.com>
Date: Sat, 30 May 2009 21:08:48 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [RFC v2 04/23] cfg80211: set WE encoding size based on available
 ciphers
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>	 <1243705017-8784-5-git-send-email-kilroyd@googlemail.com> <1243713468.3523.32.camel@localhost.localdomain>
In-Reply-To: <1243713468.3523.32.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann wrote:
>>  			range->enc_capa |= IW_ENC_CAPA_CIPHER_TKIP;
>>  		else if (suite == WLAN_CIPHER_SUITE_CCMP)
>>  			range->enc_capa |= IW_ENC_CAPA_CIPHER_CCMP;
>> +		else if (suite == WLAN_CIPHER_SUITE_WEP40)
>> +			range->encoding_size[range->num_encoding_sizes++] =
>> +				WLAN_KEY_LEN_WEP40;
>> +		else if (suite == WLAN_CIPHER_SUITE_WEP104)
>> +			range->encoding_size[range->num_encoding_sizes++] =
>> +				WLAN_KEY_LEN_WEP104;
> 
> especially since you are now extending this list, please use a switch
> statement. The code becomes hard to read.

Sure, I'll change this to a switch.

Thanks!


Dave.
