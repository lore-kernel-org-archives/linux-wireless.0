Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33498 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZDQDNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 23:13:55 -0400
Received: by ewy24 with SMTP id 24so30588ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 20:13:54 -0700 (PDT)
Message-ID: <49E7F3E6.2010809@gmail.com> (sfid-20090417_051402_881430_8CBC0C68)
Date: Fri, 17 Apr 2009 05:13:42 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Ivo van Doorn <ivdoorn@gmail.com>, stable@kernel.org,
	Arnaud Patard <apatard@mandriva.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [stable] [PATCH] rt2x00: Fix SLAB corruption during rmmod
References: <200904012118.12391.IvDoorn@gmail.com> <20090417001807.GA5020@hera.kernel.org>
In-Reply-To: <20090417001807.GA5020@hera.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

On 04/17/09 02:18, Chris Wright wrote:
> * Ivo van Doorn (ivdoorn@gmail.com) wrote:
>> At rmmod stage, the code path is the following one :
>>
>> rt2x00lib_remove_dev
>>   ->  rt2x00lib_uninitialize()
>>         -> rt2x00rfkill_unregister()
>>              -> rfkill_unregister()
>>         -> rt2x00rfkill_free()
>>              -> rfkill_free()
>>
>> The problem is that rfkill_free should not be called after rfkill_register
>> otherwise put_device(&rfkill->dev) will be called 2 times. This patch
>> fixes this by only calling rt2x00rfkill_free() when rt2x00rfkill_register()
>> hasn't been called or has failed.
>>
>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
>> Tested-by: Arnaud Patard <apatard@mandriva.com>
>> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> Who is the Author of this patch?  The Signed-off-by order suggests is
> Gertjan.
> 


Indeed, I have been the author of the patch.

---
Gertjan.
