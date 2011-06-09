Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34120 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823Ab1FINOh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 09:14:37 -0400
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] ath6kl: cache firmware
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
	<20110608115440.32208.75072.stgit@localhost6.localdomain6>
	<20110608194031.GA4069@shale.localdomain>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 09 Jun 2011 16:14:34 +0300
In-Reply-To: <20110608194031.GA4069@shale.localdomain> (Dan Carpenter's message of "Wed\, 8 Jun 2011 22\:44\:04 +0300")
Message-ID: <871uz387ut.fsf@purkki.adurom.net> (sfid-20110609_151452_408242_D3FFCC76)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <error27@gmail.com> writes:

>> --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
>> +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
>> @@ -954,9 +954,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
>>      const char *filename;
>>      const struct firmware *fw_entry;
>>      u32 fw_entry_size;
>> +    u8 **buf;
>> +    size_t *buf_len;
>
> Don't make buf_len a pointer that just makes the code messier.

I need the pointer later so that I can store the length:

            *buf_len = fw_entry->size;

>> +    if (WARN_ON((buf == NULL) || (buf_len == NULL)))
>> +	    return A_ERROR;
>
> This test is a nonsense.  "buf" and buf_len are always valid
> pointers here.

Yeah, I tried to be extra careful here, but it looks stupid now.

> Generally, I'd almost prefer a oops with a stack trace instead of
> adding in bogus error handling code for stuff that can't happen.

Depends on the case. In devices where ar6003 is usually is used there
are no serial consoles nor any other way to debug the crash.

> Also "buf" is never initialized to NULL, so if there were a
> programming bug introduced, it would generate an uninitialized
> variable warning even without the superflous test.  So lets remove
> it.

You have a point, I'll remove the test. I'll send v2.

>> +    if (*buf == NULL) {
>> +	    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osDevInfo.pOSDevice))) != 0)
>> +	    {
>             ^
>
> This is on the wrong line.

I'll answer this and all the other style comments in one go:

All the style issues are from the original code. I want to separate
functional and cleanup patches so I didn't do any cleanup in this
patch. But as we are doing the cleanup in a different tree anyway I
didn't see the point of sending a separate cleanup patch.

-- 
Kalle Valo
