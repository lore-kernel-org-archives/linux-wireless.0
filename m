Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36507 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbbGEJMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 05:12:21 -0400
Message-ID: <55980E84.1070800@gmail.com> (sfid-20150705_111225_248365_FA4918E4)
Date: Sat, 04 Jul 2015 18:49:08 +0200
From: "christophe.ricard" <christophe.ricard@gmail.com>
MIME-Version: 1.0
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: st21nfca,st-nci: fix use of uninitialized variables
 in error path
References: <1435573074-29503-1-git-send-email-nicolas.iooss_linux@m4x.org>
In-Reply-To: <1435573074-29503-1-git-send-email-nicolas.iooss_linux@m4x.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nicolas,

Thanks for your fix.
I have slit your patch for st21nfca and st-nci in order to propagate 
them in earlier kernel revision through stable@vger.kernel.org.
I will rework st-nci patch for kernel revision < 4.2

Best Regards
Christophe

On 29/06/2015 12:17, Nicolas Iooss wrote:
> st21nfca_hci_load_session() calls kfree_skb() on unitialized variables
> skb_pipe_info and skb_pipe_list if the call to nfc_hci_connect_gate()
> failed.  Reword the error path to not use these variables when they are
> not initialized.  While at it, there seemed to be a memory leak because
> skb_pipe_info was only freed once, after the for-loop, even though
> several ones were created by nfc_hci_send_cmd.
>
> st_nci_hci_load_session() is similar to st21nfca_hci_load_session(), so
> rework this function too.
>
> Fixes: ec03ff1a8f9a ("NFC: st21nfca: Remove skb_pipe_list and skb_pipe_info
> useless allocation")
>
> Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
> ---
>
> As I haven't got the hardware needed to perform tests, I only compile-tested
> this patch.
>
> Moreover I may then have missed something important for example in the way
> the memory is managed (I did not understand why skb_pipe_info was not freed
> in the for loop).
>
>   drivers/nfc/st-nci/st-nci_se.c  |  8 ++++----
>   drivers/nfc/st21nfca/st21nfca.c | 11 ++++++-----
>   2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/nfc/st-nci/st-nci_se.c b/drivers/nfc/st-nci/st-nci_se.c
> index 97addfa96c6f..c742ef65a05a 100644
> --- a/drivers/nfc/st-nci/st-nci_se.c
> +++ b/drivers/nfc/st-nci/st-nci_se.c
> @@ -189,14 +189,14 @@ int st_nci_hci_load_session(struct nci_dev *ndev)
>   				ST_NCI_DEVICE_MGNT_GATE,
>   				ST_NCI_DEVICE_MGNT_PIPE);
>   	if (r < 0)
> -		goto free_info;
> +		return r;
>   
>   	/* Get pipe list */
>   	r = nci_hci_send_cmd(ndev, ST_NCI_DEVICE_MGNT_GATE,
>   			ST_NCI_DM_GETINFO, pipe_list, sizeof(pipe_list),
>   			&skb_pipe_list);
>   	if (r < 0)
> -		goto free_info;
> +		return r;
>   
>   	/* Complete the existing gate_pipe table */
>   	for (i = 0; i < skb_pipe_list->len; i++) {
> @@ -222,6 +222,7 @@ int st_nci_hci_load_session(struct nci_dev *ndev)
>   		    dm_pipe_info->src_host_id != ST_NCI_ESE_HOST_ID) {
>   			pr_err("Unexpected apdu_reader pipe on host %x\n",
>   			       dm_pipe_info->src_host_id);
> +			kfree_skb(skb_pipe_info);
>   			continue;
>   		}
>   
> @@ -241,13 +242,12 @@ int st_nci_hci_load_session(struct nci_dev *ndev)
>   			ndev->hci_dev->pipes[st_nci_gates[j].pipe].host =
>   						dm_pipe_info->src_host_id;
>   		}
> +		kfree_skb(skb_pipe_info);
>   	}
>   
>   	memcpy(ndev->hci_dev->init_data.gates, st_nci_gates,
>   	       sizeof(st_nci_gates));
>   
> -free_info:
> -	kfree_skb(skb_pipe_info);
>   	kfree_skb(skb_pipe_list);
>   	return r;
>   }
> diff --git a/drivers/nfc/st21nfca/st21nfca.c b/drivers/nfc/st21nfca/st21nfca.c
> index d251f7229c4e..051286562fab 100644
> --- a/drivers/nfc/st21nfca/st21nfca.c
> +++ b/drivers/nfc/st21nfca/st21nfca.c
> @@ -148,14 +148,14 @@ static int st21nfca_hci_load_session(struct nfc_hci_dev *hdev)
>   				ST21NFCA_DEVICE_MGNT_GATE,
>   				ST21NFCA_DEVICE_MGNT_PIPE);
>   	if (r < 0)
> -		goto free_info;
> +		return r;
>   
>   	/* Get pipe list */
>   	r = nfc_hci_send_cmd(hdev, ST21NFCA_DEVICE_MGNT_GATE,
>   			ST21NFCA_DM_GETINFO, pipe_list, sizeof(pipe_list),
>   			&skb_pipe_list);
>   	if (r < 0)
> -		goto free_info;
> +		return r;
>   
>   	/* Complete the existing gate_pipe table */
>   	for (i = 0; i < skb_pipe_list->len; i++) {
> @@ -181,6 +181,7 @@ static int st21nfca_hci_load_session(struct nfc_hci_dev *hdev)
>   			info->src_host_id != ST21NFCA_ESE_HOST_ID) {
>   			pr_err("Unexpected apdu_reader pipe on host %x\n",
>   				info->src_host_id);
> +			kfree_skb(skb_pipe_info);
>   			continue;
>   		}
>   
> @@ -200,6 +201,7 @@ static int st21nfca_hci_load_session(struct nfc_hci_dev *hdev)
>   			hdev->pipes[st21nfca_gates[j].pipe].dest_host =
>   							info->src_host_id;
>   		}
> +		kfree_skb(skb_pipe_info);
>   	}
>   
>   	/*
> @@ -214,13 +216,12 @@ static int st21nfca_hci_load_session(struct nfc_hci_dev *hdev)
>   					st21nfca_gates[i].gate,
>   					st21nfca_gates[i].pipe);
>   			if (r < 0)
> -				goto free_info;
> +				goto free_list;
>   		}
>   	}
>   
>   	memcpy(hdev->init_data.gates, st21nfca_gates, sizeof(st21nfca_gates));
> -free_info:
> -	kfree_skb(skb_pipe_info);
> +free_list:
>   	kfree_skb(skb_pipe_list);
>   	return r;
>   }

