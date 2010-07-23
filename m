Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:12516 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0GWQLI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:11:08 -0400
Message-ID: <4C49BF18.4040106@bfs.de>
Date: Fri, 23 Jul 2010 18:11:04 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: Dan Carpenter <error27@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
References: <20100722085202.GV17585@bicker> <201007231744.14922.br1@einfach.org>
In-Reply-To: <201007231744.14922.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Bruno Randolf schrieb:

>>
>> @@ -766,6 +781,9 @@ static ssize_t read_file_queue(struct file *file, char
>> __user *user_buf, len += snprintf(buf+len, sizeof(buf)-len, "  len: %d\n",
>> n);
>>  	}
>>
>> +	if (len > sizeof(buf))
>> +		len = sizeof(buf);
>> +
>>  	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
>>  }
> 
> i think it would be better to make sure the buffer is always big enough to 
> hold all the output (it's not very variable in length), but as a safety net 
> this can't hurt.
> 


glibc provides open_memstream()/fmemopen() to write into large buffers.
I feel this as a better way than  len += snprintf(buf+len)

re,
 wh
