Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62165 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2DRSXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 14:23:39 -0400
Received: by dake40 with SMTP id e40so10225479dak.11
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 11:23:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOZOX0WqWJOD3Uv5FuTURzD4W-YAr0mADqpFGZ5SMzkNV1ruiQ@mail.gmail.com>
References: <1334768863-26839-1-git-send-email-anisse@astier.eu>
 <1334768863-26839-2-git-send-email-anisse@astier.eu> <CAOZOX0WqWJOD3Uv5FuTURzD4W-YAr0mADqpFGZ5SMzkNV1ruiQ@mail.gmail.com>
From: Anisse Astier <anisse@astier.eu>
Date: Wed, 18 Apr 2012 20:23:18 +0200
Message-ID: <CALUN=qLX8Fop06-WshoR8ju3MPi8dHDNJpzk7vJ8S6cUteHPrQ@mail.gmail.com> (sfid-20120418_202342_618983_5B36B2B1)
Subject: Re: [PATCH RFC 2/2] rt2x00: Add debugfs access for rfcsr register
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, Helmut Schaa <helmut.schaa@googlemail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 7:23 PM, Ivo Van Doorn <ivdoorn@gmail.com> wrote:
> Hi,
>
>>  drivers/net/wireless/rt2x00/rt2400pci.c   |    7 +++++++
>>  drivers/net/wireless/rt2x00/rt2500pci.c   |    7 +++++++
>>  drivers/net/wireless/rt2x00/rt2500usb.c   |    7 +++++++
>>  drivers/net/wireless/rt2x00/rt2800.h      |    2 ++
>>  drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +++++++
>>  drivers/net/wireless/rt2x00/rt2x00debug.c |   12 ++++++++++++
>>  drivers/net/wireless/rt2x00/rt2x00debug.h |    1 +
>>  drivers/net/wireless/rt2x00/rt61pci.c     |    7 +++++++
>>  drivers/net/wireless/rt2x00/rt73usb.c     |    7 +++++++
>>  9 files changed, 57 insertions(+)
>
> Would it be possible to add this regisrer without editing every module?
Not easy from looking at the code. The implementation lying in
rt2x00debug is a common thing.

I considered using "rf" instead, since this isn't used in rt2800. But
the rf register has a 32bits word size, while rfcsr has an 8bits word
size. Also, they do not designate the same thing, even if they're used
the same way.

We could rely on the fact that C struct initialization would be
zeroed, since we're using per-member designated initialization(C99).
It works with the current code because the functions
rt2x00debug_{read,write}_##__name check if the index is > word_count
before doing anything.
I didn't like it because it would then be implicit, but it could do the work.

>
>> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
>> @@ -70,6 +70,7 @@ struct rt2x00debug_intf {
>>         *     - eeprom offset/value files
>>         *     - bbp offset/value files
>>         *     - rf offset/value files
>> +        *     - rfcsr offset/value files
>>         *   - queue folder
>>         *     - frame dump file
>>         *     - queue stats file
>> @@ -89,6 +90,8 @@ struct rt2x00debug_intf {
>>        struct dentry *bbp_val_entry;
>>        struct dentry *rf_off_entry;
>>        struct dentry *rf_val_entry;
>> +       struct dentry *rfcsr_off_entry;
>> +       struct dentry *rfcsr_val_entry;
>>        struct dentry *queue_folder;
>>        struct dentry *queue_frame_dump_entry;
>>        struct dentry *queue_stats_entry;
>> @@ -131,6 +134,7 @@ struct rt2x00debug_intf {
>>        unsigned int offset_eeprom;
>>        unsigned int offset_bbp;
>>        unsigned int offset_rf;
>> +       unsigned int offset_rfcsr;
>>  };
>>
>>  void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
>> @@ -525,6 +529,7 @@ RT2X00DEBUGFS_OPS(csr, "0x%.8x\n", u32);
>>  RT2X00DEBUGFS_OPS(eeprom, "0x%.4x\n", u16);
>>  RT2X00DEBUGFS_OPS(bbp, "0x%.2x\n", u8);
>>  RT2X00DEBUGFS_OPS(rf, "0x%.8x\n", u32);
>> +RT2X00DEBUGFS_OPS(rfcsr, "0x%.2x\n", u8);
>>
>>  static ssize_t rt2x00debug_read_dev_flags(struct file *file,
>>                                          char __user *buf,
>> @@ -640,6 +645,10 @@ static struct dentry
>> *rt2x00debug_create_file_chipset(const char *name,
>>                        debug->rf.word_base,
>>                        debug->rf.word_count,
>>                        debug->rf.word_size);
>> +       data += sprintf(data, "rfcsr\t%d\t%d\t%d\n",
>> +                       debug->rf.word_base,
>> +                       debug->rf.word_count,
>> +                       debug->rf.word_size);
>>        blob->size = strlen(blob->data);
>
> Shouldn't this be rfcr?
Oh. Yes, it should be.


>
> Ivo
