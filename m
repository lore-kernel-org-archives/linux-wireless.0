Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:49642 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755051AbZCLCjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 22:39:45 -0400
Date: Wed, 11 Mar 2009 18:13:28 -0700 (PDT)
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	bzhao@marvell.com
Subject: Re: [PATCH resend] libertas: support mesh for various firmware
 versions
Message-ID: <alpine.LFD.0.9999.0903111802190.6150@localhost.localdomain> (sfid-20090312_033954_691377_40996C98)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, March 11, 2009 at 3:26 AM, Dan Williams wrote:

>> +		struct {
>> +			/* packet type */
>> +			u8 pkt_type;
>> +			/* BSS number */
>> +			u8 bss_num;
>
> Any chance you could give a quick overview of what goes in the
> pkt_type and bss_num fields?

Hi Dan,

This is to support multiple BSS simultaneously with the same
firmware at runtime. Each BSS has a unique number (bss_num) and
may have different type, such as "client", "AP", etc.

The bss_num of mesh interface is defined as a macro
"MESH_IFACE_ID" in this patch. The pkt_type field is reserved
for future use.


>> +		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
>> +			if (p_rx_pd->u.stat.bss_num)
>
> This would mean that bss_num == 0 indicates a regular frame.  Is
> that correct?  For mesh frames bss_num will always be > 0?  The
> old-style rx_control flag seems a bit cleaner to me, but whatever
> works :)

It should be like this, thanks!
+		} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
+			if (p_rx_pd->u.stat.bss_num == MESH_IFACE_ID)

>> -	if (!(p_rx_pd->status & cpu_to_le16(MRVDRV_RXPD_STATUS_OK))) {
>> -		lbs_deb_rx("rx err: frame received with bad status\n");
>> -		lbs_pr_alert("rxpd not ok\n");
>> -		priv->stats.rx_errors++;
>> -		ret = 0;
>> -		goto done;
>> -	}
>> -
>
> I'd prefer to keep this code; can you protect it with firmware version
> checks for firmware < 5.1?  It looks like those older firmware versions
> use it, but the 5.1 specification marks RxStatus "Reserved".  Since the
> driver still works with cf8385 and sd8385 using firmware 5.0.16 and
> such, I'm not sure we should remove this yet.

The firmware seems always set MRVDRV_RXPD_STATUS_OK bit in status field.
I'll double check for this with the old firmware v5.0.16.

The patch will be re-sent to address above issues.

Thanks,

Bing

