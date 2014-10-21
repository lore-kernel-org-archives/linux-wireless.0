Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37793 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaJUG4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 02:56:10 -0400
Received: by mail-wi0-f171.google.com with SMTP id em10so9058650wid.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 23:56:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com>
References: <1413823085-3187-1-git-send-email-yanbol@qti.qualcomm.com>
Date: Tue, 21 Oct 2014 08:56:08 +0200
Message-ID: <CA+BoTQn85nV3KSVcwG7k7hBPhZqbLRyFqK54QYJuLemuNoE4mw@mail.gmail.com> (sfid-20141021_085615_063783_6BE661AC)
Subject: Re: [PATCH v3] Add the target register read/write and memory dump
 debugfs interface
From: Michal Kazior <michal.kazior@tieto.com>
To: Yanbo Li <yanbol@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	ath10k-devel <ath10k-devel@qca.qualcomm.com>,
	"Balasubramanian, Senthil Kumar" <senthilb@qti.qualcomm.com>,
	dreamfly281@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You're missing "ath10k: " prefix in the patch subject.


On 20 October 2014 18:38, Yanbo Li <yanbol@qti.qualcomm.com> wrote:
> The debugfs interface reg_addr&reg_val used to read and write the target
> register.
> The interface mem_addr&mem_val used to dump the targer memory and also
> can be used to assign value to target memory
>
> The basic usage explain as below:
>
> Register read/write:
> reg_addr       (the register address)                    (read&write)
> reg_value      (the register value,  output is ASCII)    (read&write)
>
> Read operation:
> 1. Write the reg address to reg_addr
>    IE:  echo 0x100000 > reg_addr
> 2. Read the value from reg_value
>    IE:  cat reg_value
> Write operation:
> 1. Write the reg address to reg_addr IE:  echo 0x100000 > reg_addr
> 2. Write the value to the reg_value  IE:  echo  0x2400 > reg_value
>
> Target memory dump:
> mem_addr (the memory address the length also can used as the second
> paramenter address length)                              (read&write)
> mem_value (the content of the memory with the length, output is binary)
>                                                         (read&write)
> Read operation:
> 1. Write the address and length to mem_addr
>    IE:  echo 0x400000 1024 > mem_addr

So mem_addr is actually used to store both _addr_ and _length_. I
think length could be skipped and be read implicitly from each read()
request along with the offset. This way userspace would be able to
determine read length on demand, e.g. via "dd if=mem_value bs=1024
count=4" (read 4 KiB of data). If you want to see hex, you would pipe
it through "hexdump" or "xxd" or your other favourite hexdump program.
Or even better - you could drop the mem_addr altogether and expect
userspace to seek & read/write data it wants via, e.g. `dd` program:

  dd if=mem_value bs=1 count=1024 skip=$(printf "%d" 0x400000) | xxd -g1
  echo 0x01020304 | xxd -r | dd of=mem_value bs=1 seek=$(printf "%d" 0x400400)


> 2. Read the value from mem value, the output is binary format
>    IE:  hexdump mem_value
> Write operation:
> 1. Write the start mem address to mem_addr
>    IE:  echo 0x400000 > mem_addr
> 2. Dump the binary value to the mem_value
>    IE:  echo  0x2400 > mem_value or echo 0x2400 0x3400 ... > mem_addr
>    (the value number should be separated with spacebar)

I don't really like the idea of input being different than the output,
but maybe that's just me.


[...]
> +static ssize_t ath10k_mem_value_write(struct file *file,
> +                                     const char __user *user_buf,
> +                                     size_t count, loff_t *ppos)
> +{
> +       struct ath10k *ar = file->private_data;
> +       u8 *buf;
> +       __le32 *value;
> +       char *sptr, *token;
> +       int i, ret;
> +       u32 mem_addr;
> +       u32 mem_val;
> +
> +       mem_addr =  ar->debug.mem_addr;

There's double space following "=".


[...]
> +       i = 0;
> +       while (sptr) {
> +               if (!sptr)
> +                       break;
> +
> +               token = strsep(&sptr, " ");
> +
> +               ret = kstrtou32(token, 0, &mem_val);
> +               if (ret)
> +                       goto err_free_value;
> +
> +               value[i] = mem_val;
> +               i++;
> +       }
> +
> +       ret = ath10k_hif_diag_write(ar, mem_addr, (const void *)value,
> +                                   i * sizeof(mem_val));
> +       if (ret) {
> +               ath10k_warn(ar, "failed to write address 0x%08x via diagnose window from debugfs: %d\n",
> +                           mem_addr, ret);
> +               goto err_free_value;
> +       }

I believe userspace may call write() multiple number of times with
different offsets and fragment the data breaking it in the middle of
your string hex words. This code will most likely fail with larger
chunks of data or you can try to simulate the fragmentation with:

  echo 0x0001 0x0002 | dd bs=1 of=mem_value

(Please correct me if I'm wrong :-)


Michał
