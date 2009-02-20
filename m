Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:52122 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbZBTTTW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 14:19:22 -0500
Received: by bwz5 with SMTP id 5so2914619bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 11:19:20 -0800 (PST)
Message-ID: <499F0231.5080103@gmail.com> (sfid-20090220_201926_792843_E931EE54)
Date: Fri, 20 Feb 2009 19:19:13 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH 1/2] orinoco: validate firmware header
References: <1235087187-23425-1-git-send-email-kilroyd@googlemail.com> <1235087187-23425-2-git-send-email-kilroyd@googlemail.com> <200902202126.12230.arvidjaar@mail.ru>
In-Reply-To: <200902202126.12230.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On 20 of February 2009 02:46:26 David Kilroy wrote:
>> +static const char *fw_err[] = {
>> +	"image too small",
>> +};
>> +
>>
>> +/* Check the range of various header entries */
>> +static int validate_fw(const struct orinoco_fw_header *hdr, size_t
>> len) +{
>> +	if (len < sizeof(*hdr))
>> +		return 1;
>> +
>> +	/* TODO: consider adding a checksum or CRC to the firmware format
>> */ +	return 0;
>> +}
> 
> 
> I am afraid this can easily go off sync. Any reason those messages 
> cannot be printed inline in validate_fw()?

That's how I started, but I didn't like having to pass down struct
net_device/struct orinoco_private just to print an error.

> Otherwise what about
> 
> #define FW_ERR_OK	0
> #define FW_ERR_TOO_SMALL 1
> ...
> static const char *fw_err[] = {
> 	[FW_ERR_TOO_SMALL] = "image too small",
> ?

Sure. That (or an enumeration) documents the error codes. A little
tedious though. What if I did something like:

static char * validate_fw(...)
{
   if (len < sizeof(*hdr))
      return "image too small";
   ...

   return NULL;
}

...
{
   char *fw_err = validate_firmware(hdr, fw_entry->size);

   if (fw_err != NULL) {
       printk(KERN_WARNING "%s: Invalid firmware (%s)\n",
	      dev->name, fw_err)
       err = -EINVAL;
       goto abort;
   }
}


Dave.
