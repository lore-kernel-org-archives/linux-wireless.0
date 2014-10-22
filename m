Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64422 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaJVGrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 02:47:55 -0400
Received: by mail-wi0-f172.google.com with SMTP id bs8so427328wib.5
        for <linux-wireless@vger.kernel.org>; Tue, 21 Oct 2014 23:47:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8F62F6322D7B2E46AD0AB51C2C2A02FD230A984B@NASANEXD01D.na.qualcomm.com>
References: <8F62F6322D7B2E46AD0AB51C2C2A02FD230A984B@NASANEXD01D.na.qualcomm.com>
Date: Wed, 22 Oct 2014 08:47:53 +0200
Message-ID: <CA+BoTQ=rKTrrMgyP6YTPRLGT1+NDEbzxrBt6Zv=r2fk9Ri3VLA@mail.gmail.com> (sfid-20141022_084758_758685_D10D8535)
Subject: Re: [PATCH v3] ath10k: Add the target register read/write and memory
 dump debugfs interface
From: Michal Kazior <michal.kazior@tieto.com>
To: "Li, Yanbo" <yanbol@qti.qualcomm.com>
Cc: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	ath10k-devel <ath10k-devel@qca.qualcomm.com>,
	"Balasubramanian, Senthil Kumar" <senthilb@qti.qualcomm.com>,
	"dreamfly281@gmail.com" <dreamfly281@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2014 17:10, Li, Yanbo <yanbol@qti.qualcomm.com> wrote:
>> -----Original Message-----
>> From: Michal Kazior [mailto:michal.kazior@tieto.com]
>> On 20 October 2014 18:38, Yanbo Li <yanbol@qti.qualcomm.com> wrote:
[...]
>> > 2. Read the value from mem value, the output is binary format
>> >    IE:  hexdump mem_value
>> > Write operation:
>> > 1. Write the start mem address to mem_addr
>> >    IE:  echo 0x400000 > mem_addr
>> > 2. Dump the binary value to the mem_value
>> >    IE:  echo  0x2400 > mem_value or echo 0x2400 0x3400 ... > mem_addr
>> >    (the value number should be separated with spacebar)
>>
>> I don't really like the idea of input being different than the output, but maybe that's
>> just me.
>>
>
> Hmm, I will implement  another version to keep the read and write use the same interface,
> the extra effort is the user need edit the binary file to construct the input number.

There's plenty of tools that can do that for you, e.g. xxd. If
mem_value would expect binary input you could do:

  echo 0x01 0x02 0x03 0x04 | xxd -r > mem_value

This would effectively put 4 bytes into the mem_value. Or you can use
perl and pack() to create endianess aware byte streams.


[...]
>> > +       i = 0;
>> > +       while (sptr) {
>> > +               if (!sptr)
>> > +                       break;
>> > +
>> > +               token = strsep(&sptr, " ");
>> > +
>> > +               ret = kstrtou32(token, 0, &mem_val);
>> > +               if (ret)
>> > +                       goto err_free_value;
>> > +
>> > +               value[i] = mem_val;
>> > +               i++;
>> > +       }
>> > +
>> > +       ret = ath10k_hif_diag_write(ar, mem_addr, (const void *)value,
>> > +                                   i * sizeof(mem_val));
>> > +       if (ret) {
>> > +               ath10k_warn(ar, "failed to write address 0x%08x via diagnose window
>> from debugfs: %d\n",
>> > +                           mem_addr, ret);
>> > +               goto err_free_value;
>> > +       }
>>
>> I believe userspace may call write() multiple number of times with different offsets
>> and fragment the data breaking it in the middle of your string hex words. This
>> code will most likely fail with larger chunks of data or you can try to simulate the
>> fragmentation with:
>>
>>   echo 0x0001 0x0002 | dd bs=1 of=mem_value
>>
>> (Please correct me if I'm wrong :-)
>>
> Not full understand what’s you mean, do you mean this segment need be protect with lock
> to avoid multi write operation access the mem_value at the same time?

This is not a problem with locking. The problem is you assume
ath10k_mem_value_write() is going to be called once.

I'm pretty sure that the above example (dd bs=1) will yield many
ath10k_mem_value_write() each with a single-byte buffer. This means
two things:
 a) kstrotu32() parsing will break
 b) you always call ath10k_hif_diag_write() with mem_addr without any
offset so even if (a) is ignored you'll just keep overwriting first
word in target memory over and over again

Having binary input (instead of hex string words) is going to help
with (a). To fix (b) you'll need to add *ppos to mem_addr when you
call ath10k_hif_diag_write().


Michał
