Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0CB9C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBE620850
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 06:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RLKyRjyV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbfDJG7M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:59:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50596 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728647AbfDJG7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 02:59:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3A6s3KB107629;
        Wed, 10 Apr 2019 06:56:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=eUy6uNd20IYE0HM61hq/WDfOphNCC2hmiq/ognC0Li0=;
 b=RLKyRjyVa1eDa8Wtlw0800FywfAOqyVuwzvDOe+0DCgQQRFWcxH4tB947aFQDZ2vFfCv
 Ot7KxM2KJKfq2xNinZqcgvWuh3nidCddrNcRmpkwwcqg0fiad9WgaPUUrNUZsemyPHNa
 7SUqb7ipupeQWGRMqx3LUpyOM+z3h43BScoqp05ktY0pWxOJo49KRLb7jDBHkqrYG0N5
 wpIincfr87c1v7e6iES1tBNxOKIW3vLq0WwtzxdqXZXnoYBUOEuyw4+jn0lMUwXYYtw2
 SiO5WtUp1RSXG3djmjhC+WvC2DZ5fu25eTcj8slgDF8bUafIEgq4hI8k0plONv8ktNPr Uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2rpmrq9365-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Apr 2019 06:56:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3A6tdvQ002850;
        Wed, 10 Apr 2019 06:56:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2rpytc2p5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Apr 2019 06:56:57 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3A6ukAF026990;
        Wed, 10 Apr 2019 06:56:46 GMT
Received: from kadam (/197.157.0.42)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Apr 2019 23:56:45 -0700
Date:   Wed, 10 Apr 2019 09:56:27 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "Alastair D'Silva" <alastair@au1.ibm.com>
Cc:     alastair@d-silva.org, linux-fbdev@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        David Airlie <airlied@linux.ie>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        linux-fsdevel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Benson Leung <bleung@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, netdev@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
Message-ID: <20190410065627.GF6095@kadam>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410031720.11067-4-alastair@au1.ibm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9222 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=630
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904100050
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9222 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=652 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904100050
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 10, 2019 at 01:17:19PM +1000, Alastair D'Silva wrote:
> @@ -107,7 +108,7 @@ EXPORT_SYMBOL(bin2hex);
>   * string if enough space had been available.
>   */
>  int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
> -		       char *linebuf, size_t linebuflen, bool ascii)
> +		       char *linebuf, size_t linebuflen, u64 flags)
>  {
>  	const u8 *ptr = buf;
>  	int ngroups;
> @@ -184,7 +185,7 @@ int hex_dump_to_buffer(const void *buf, size_t len, int rowsize, int groupsize,
>  		if (j)
>  			lx--;
>  	}
> -	if (!ascii)
> +	if (!flags & HEXDUMP_ASCII)
            ^^^^^^^^^^^^^^^^^^^^^^
This is a precedence bug.  It should be if (!(flags & HEXDUMP_ASCII)).


>  		goto nil;
>  

regards,
dan carpenter


