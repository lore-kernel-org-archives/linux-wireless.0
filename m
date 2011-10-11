Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35262 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab1JKSwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 14:52:50 -0400
Date: Tue, 11 Oct 2011 21:52:28 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] ath6kl: Add endpoint_stats debugfs file
Message-ID: <20111011185228.GA20806@jouni.qca.qualcomm.com> (sfid-20111011_205255_470704_55558AE8)
References: <1318343517-15292-1-git-send-email-jouni@qca.qualcomm.com>
 <1318343517-15292-2-git-send-email-jouni@qca.qualcomm.com>
 <1318351171.1839.43.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1318351171.1839.43.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 09:39:31AM -0700, Joe Perches wrote:
> > +static unsigned int print_endpoint_stat(struct htc_target *target, char *buf,
> > +					unsigned int buf_len, unsigned int len,
> > +					int offset, const char *name)
> 
> Perhaps the function name is wrong.
> This doesn't print, it fills a buffer.

Well, it prints the stuff into a buffer just like scnprintf prints
things.. Feel free to send a patch if you want to try to rename
*print* functions ;-).

> len and offset are to me oddly used variable names.

I guess len could be renamed to pos, but the use of len here matches
with the function used in the main function, i.e., this
print_endpoint_stat is more of a replacement for a macro. offset sounds
correct to me, i.e., it is the offset within the statistics structure.

> > +		counter = ((u32 *) ep_st) + (offset / 4);

> perhaps:
> 
> static int endpoint_stats(struct htc_target *target,
> 			  char *buf, size_t len,
> 			  size_t pos, int index, const char *name)

I would have nothing against pos, but index would be a bit confusing
here since that parameter is really the byte offset and not the index.

> 	pos += scnprintf(buf + pos, len - pos, "%s:", name);
> 	for (i = 0; i < ENDPOINT_MAX; i++) {
> 		u32 *stats = (u32 *)&target->endpoint[i].ep_st;
> 		offset += scnprintf(buf + pos, len - pos, " %u", stats[index]);

Well, okay, index to a u32 array.. If you feel strongly enough, please
send a separate cleanup patch since Kalle applied this already.


> > +static ssize_t ath6kl_endpoint_stats_read(struct file *file,
> > +					  char __user *user_buf,
> > +					  size_t count, loff_t *ppos)
> > +{
> > +	struct ath6kl *ar = file->private_data;
> > +	struct htc_target *target = ar->htc_target;
> > +	char *buf;
> > +	unsigned int buf_len, len = 0;
> 
> size_t len = 0;
> (or maybe pos instead)

This follows the style used throughout this file. Feel free to propose
cleanup to all the functions.

> 
> > +	ssize_t ret_cnt;
> > +
> > +	buf_len = 1000 + ENDPOINT_MAX * 100;
> 
> It seems odd to start with size using 1000

Yeah.. I think I had something as a prefix first and then just forgot to
remove that extra addition.

> There's ENDPOINT_MAX rows (9)
> Each row contains:
> 	up to 20 byte row name
> 	20 counters * up to 10 bytes per counter
> up to 220 bytes per row

It's actually the other way around, i.e., 20 rows with 9 counters.

> Perhaps this?
> 	const size_t buf_len = ENDPOINT_MAX * (20 + sizeof(struct htc_endpoint_stats) / sizeof(u32) * 10);

I was too lazy to count the exact maximum. If there is any chance of
overflowing the buf_len, this would obviously need to be fixed. The
theoretical maximum would likely be something like 20 * (22 + 9 * 11),
so yes, while I don't think this happens in practice, this buffer length
should be incremented to cover the theoretical case (and to make some
more sense).

> > +	buf = kzalloc(buf_len, GFP_KERNEL);
> 
> kzalloc doesn't seem necessary,
> everything is overwritten.  just kmalloc?

Yeah, I probably copied that from an existing function, but I would
agree that that is not really any need for clearing the buffer.

> As is, it's (barely) possible to overflow
> the buffer length and end up non-null terminated.
> Perhaps that doesn't matter.

I don't think there is any need for null-terminating the buffer since
this is really binary data with length returned. As I noted, this is
unlikely to end up having large enough counter values to overflow in
practice, but changing the buf_len calculation to make more sense is
useful cleanup anyway.

> > +	len = print_endpoint_stat(target, buf, buf_len, len,		\
> > +				  offsetof(struct htc_endpoint_stats, name), \
> > +				  #name)
> 
> perhaps
> 
> #define EPSTAT(name)							\
> 	len = endpoint_stat(target, buf, buf_len, len,			\
> 			    offsetof(struct htc_endpoint_stats, name) / sizeof(u32), \
> 			    #name)

I'm fine with this, too, as a separate cleanup patch.

> > +	if (len > buf_len)
> > +		len = buf_len;
> 
> Maybe it's better to ensure 0 termination?
> 	if (len > buf_len) {
> 		len = buf_len;
> 		buf[buf_len - 1] = 0;
> 	}

Why? This is a read file op.. It is not like the caller is expecting a
null-terminated string to come back from here.

-- 
Jouni Malinen                                            PGP id EFC895FA
