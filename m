Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:40143 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2JIM0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 08:26:10 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Szymon Janc <szymon.janc@tieto.com>
Subject: RE: NFC: Set local general bytes in nci_start_poll
Date: Tue, 9 Oct 2012 12:26:02 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803516AE0184@DNCE04.ent.ti.com> (sfid-20121009_142614_618804_40FD9B44)
References: <20120926140553.GA31568@elgon.mountain>
In-Reply-To: <20120926140553.GA31568@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Sorry for the late response, I was on vacation. 

> Hello Ilan Elias,
> 
> The patch 7e0352306f68: "NFC: Set local general bytes in 
> nci_start_poll" from Aug 15, 2012, leads to the following warning:
> net/nfc/nci/core.c:427 nci_set_local_general_bytes()
> 	 error: buffer overflow 'local_gb' 48 <= 250
> 
>    416          __u8 local_gb[NFC_MAX_GT_LEN];
>                               ^^^^^^^^^^^^^^
> 48 elements.
> 
>    417          int i, rc = 0;
>    418  
>    419          param.val = 
> nfc_get_local_general_bytes(nfc_dev, &param.len);
>    420          if ((param.val == NULL) || (param.len == 0))
>    421                  return rc;
>    422  
>    423          if (param.len > NCI_MAX_PARAM_LEN)
>                                 ^^^^^^^^^^^^^^^^^
> Capped at 250.  Probably NFC_MAX_GT_LEN was intended?
> 
>    424                  return -EINVAL;
>    425  
>    426          for (i = 0; i < param.len; i++)
>    427                  local_gb[param.len-1-i] = param.val[i];
>                                  ^^^^^^^^^^^^^
> Writing to the 250th element.
> 
> This is just a sanity check and nfc_get_local_general_bytes() 
> will only
> return NFC_MAX_GT_LEN max because of the check in nfc_llcp_build_gb().

You're right.
I see now that Szymon Janc already sent a patch for this a few days ago.

Thanks & BR,
Ilan

