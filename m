Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:49910 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYGXVg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2008 17:36:26 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3674630wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2008 14:36:24 -0700 (PDT)
Message-ID: <40f31dec0807241436v4d3c217bne359a5230143d1a3@mail.gmail.com> (sfid-20080724_233629_021057_43765747)
Date: Fri, 25 Jul 2008 00:36:24 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH 2/12] ath5k: Restore saved initval after POST
Cc: "Nick Kossifidis" <mick@madwifi.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <1216934788.3094.8.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080720033232.GB7440@makis> <1216934788.3094.8.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/25 Pavel Roskin <proski@gnu.org>:
> On Sun, 2008-07-20 at 06:32 +0300, Nick Kossifidis wrote:
>> * Restore saved initial value after POST
> ...
>> @@ -170,6 +172,10 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
>>                       var_pattern = 0x003b080f;
>>                       ath5k_hw_reg_write(ah, var_pattern, cur_reg);
>>               }
>> +
>> +             /* Restore previous value */
>> +             ath5k_hw_reg_write(ah, init_val, cur_reg);
>> +
>>       }
>
> Perhaps "at the end of POST"?  Anyway, the code looks good to me.
>

We are not restoring at the end of POST but after we end with each of
the two registers, so i guess it's ok this way



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
