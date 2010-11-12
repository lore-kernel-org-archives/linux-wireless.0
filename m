Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0KLUSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 15:18:24 -0500
Received: by wyb28 with SMTP id 28so2302355wyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 12:18:23 -0800 (PST)
Message-ID: <4CDDA103.3010209@lwfinger.net>
Date: Fri, 12 Nov 2010 14:18:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "miloofr@gmail.com" <miloofr@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about Edimax 7811Un
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>	<0022152d6729673f6a0494b1f2e6@google.com>	<AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>	<4CDAB99D.7030100@lwfinger.net>	<AANLkTik9=-8bXNOvrY-JnFuVJr1wZG24o8m8JzJVD8tQ@mail.gmail.com>	<4CDC049C.90005@lwfinger.net> <AANLkTi=JG=5tX2zcXOCdtUMHcASaZOWppZzb4vLyJSxc@mail.gmail.com>
In-Reply-To: <AANLkTi=JG=5tX2zcXOCdtUMHcASaZOWppZzb4vLyJSxc@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090201000108000304030307"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090201000108000304030307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Eric,

Attached is a patch that compiles cleanly on a 64-bit system. I have not tested
it as I have no device.

There are two kinds of differences between 32- and 64-bit systems. The first is
the size of a pointer, which becomes important whenever there is a need to keep
one as an integer. The original driver stores them into a u32 or a uint, which
is too short. These problems are solved by storing such values in variables of
__kernel_size_t. The second problem occurs for the communication buffers. There
are 4 quantities: head, data, tail and end. For both 32- and 64-bit systems,
head and data are pointers. With 32 bits, so are tail and end, but for 64 bits,
tail and end are uint.

I got all the ones the compiler complained about.

Larry


--------------090201000108000304030307
Content-Type: text/plain;
 name="convert_to_64bit"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="convert_to_64bit"

Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_cmd.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_cmd.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_cmd.c
@@ -84,7 +84,7 @@ _func_enter_;
 		goto exit;
 	}
 	
-	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ( (uint)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
+	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((__kernel_size_t)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
 		
 	pcmdpriv->rsp_allocated_buf = _rtw_malloc(MAX_RSPSZ + 4);
 	
@@ -93,7 +93,7 @@ _func_enter_;
 		goto exit;
 	}
 	
-	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ( (uint)(pcmdpriv->rsp_allocated_buf) & 3);
+	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ((__kernel_size_t)(pcmdpriv->rsp_allocated_buf) & 3);
 
 	pcmdpriv->cmd_issued_cnt = pcmdpriv->cmd_done_cnt = pcmdpriv->rsp_cnt = 0;
 
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_ioctl_set.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_ioctl_set.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_ioctl_set.c
@@ -1029,7 +1029,7 @@ _func_enter_;
 	{
 		u8 ret;		
 		u32 keyindex;		
-		u32 len = FIELD_OFFSET(NDIS_802_11_KEY, KeyMaterial) + key->KeyLength;
+		__kernel_size_t len = FIELD_OFFSET(NDIS_802_11_KEY, KeyMaterial) + key->KeyLength;
 		NDIS_802_11_WEP *wep = &padapter->securitypriv.ndiswep;
 				
 		RT_TRACE(_module_rtl871x_ioctl_set_c_,_drv_err_,("OID_802_11_ADD_KEY: +++++ WEP key +++++\n"));
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_mlme_ext.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_mlme_ext.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_mlme_ext.c
@@ -668,9 +668,9 @@ unsigned int OnAuthClient(_adapter *pada
 
 	offset = (GetPrivacy(pframe))? 4: 0;
 
-	algthm 	= le16_to_cpu(*(unsigned short *)((unsigned int)pframe + WLAN_HDR_A3_LEN + offset));
-	seq 	= le16_to_cpu(*(unsigned short *)((unsigned int)pframe + WLAN_HDR_A3_LEN + offset + 2));
-	status 	= le16_to_cpu(*(unsigned short *)((unsigned int)pframe + WLAN_HDR_A3_LEN + offset + 4));
+	algthm 	= le16_to_cpu(*(unsigned short *)((__kernel_size_t)pframe + WLAN_HDR_A3_LEN + offset));
+	seq 	= le16_to_cpu(*(unsigned short *)((__kernel_size_t)pframe + WLAN_HDR_A3_LEN + offset + 2));
+	status 	= le16_to_cpu(*(unsigned short *)((__kernel_size_t)pframe + WLAN_HDR_A3_LEN + offset + 4));
 
 	if (status != 0)
 	{
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_recv.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_recv.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_recv.c
@@ -91,7 +91,7 @@ _func_enter_;
 	_rtw_memset(precvpriv->pallocated_frame_buf, 0, NR_RECVFRAME * sizeof(union recv_frame) + RXFRAME_ALIGN_SZ);
 
 	precvpriv->precv_frame_buf = precvpriv->pallocated_frame_buf + RXFRAME_ALIGN_SZ -
-							((uint) (precvpriv->pallocated_frame_buf) &(RXFRAME_ALIGN_SZ-1));
+							((__kernel_size_t) (precvpriv->pallocated_frame_buf) &(RXFRAME_ALIGN_SZ-1));
 
 	precvframe = (union recv_frame*) precvpriv->precv_frame_buf;
 
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_security.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_security.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_security.c
@@ -245,7 +245,7 @@ _func_enter_;
 				arcfour_encrypt(&mycontext, payload+length, crc, 4);
 	
 			pframe+=pxmitpriv->frag_len;
-			pframe=(u8 *)RND4((uint)(pframe));
+			pframe=(u8 *)RND4((__kernel_size_t)(pframe));
 
 			}
 			
@@ -741,7 +741,7 @@ _func_enter_;
 					arcfour_encrypt(&mycontext, payload+length, crc, 4);
 	
 				pframe+=pxmitpriv->frag_len;
-				pframe=(u8 *)RND4((uint)(pframe));
+				pframe=(u8 *)RND4((__kernel_size_t)(pframe));
 
 				}
 			}
@@ -1557,7 +1557,7 @@ _func_enter_;
 				
 					aes_cipher(prwskey,pattrib->hdrlen,pframe, length);
 				pframe+=pxmitpriv->frag_len;
-				pframe=(u8*)RND4((uint)(pframe));
+				pframe=(u8*)RND4((__kernel_size_t)(pframe));
 
 				}
 			}
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_xmit.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_xmit.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_xmit.c
@@ -134,7 +134,7 @@ _func_enter_;
 		goto exit;
 	}
 	pxmitpriv->pxmit_frame_buf = pxmitpriv->pallocated_frame_buf + 4 -
-							((uint) (pxmitpriv->pallocated_frame_buf) &3);
+							((__kernel_size_t) (pxmitpriv->pallocated_frame_buf) &3);
 
 	pxframe = (struct xmit_frame*) pxmitpriv->pxmit_frame_buf;
 
@@ -173,7 +173,7 @@ _func_enter_;
 	}
 
 	pxmitpriv->pxmitbuf = pxmitpriv->pallocated_xmitbuf + 4 -
-							((uint) (pxmitpriv->pallocated_xmitbuf) &3);
+							((__kernel_size_t) (pxmitpriv->pallocated_xmitbuf) &3);
 
 	pxmitbuf = (struct xmit_buf*)pxmitpriv->pxmitbuf;
 
@@ -191,7 +191,7 @@ _func_enter_;
 			goto exit;
 		}
 
-		pxmitbuf->pbuf = pxmitbuf->pallocated_buf + XMITBUF_ALIGN_SZ -((uint) (pxmitbuf->pallocated_buf) &(XMITBUF_ALIGN_SZ-1));
+		pxmitbuf->pbuf = pxmitbuf->pallocated_buf + XMITBUF_ALIGN_SZ -((__kernel_size_t) (pxmitbuf->pallocated_buf) &(XMITBUF_ALIGN_SZ-1));
 
 		rtw_os_xmit_resource_alloc(padapter, pxmitbuf);
 
@@ -843,7 +843,7 @@ _func_enter_;
 			payload=pframe;
 
 			for(curfragnum=0;curfragnum<pattrib->nr_frags;curfragnum++){
-				payload=(u8 *)RND4((uint)(payload));
+				payload=(u8 *)RND4((__kernel_size_t)(payload));
 				RT_TRACE(_module_rtl871x_xmit_c_,_drv_err_,("===curfragnum=%d, pframe= 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x, 0x%.2x,!!!\n",
 					curfragnum,*payload, *(payload+1),*(payload+2),*(payload+3),*(payload+4),*(payload+5),*(payload+6),*(payload+7)));
 
@@ -1107,7 +1107,7 @@ s32 rtw_xmitframe_coalesce(_adapter *pad
 
 	s32 frg_inx, frg_len, mpdu_len, llc_sz, mem_sz;
 
-	u32 addr;
+	__kernel_size_t addr;
 
 	u8 *pframe, *mem_start, *ptxdesc;
 
@@ -1282,7 +1282,7 @@ _func_enter_;
 #endif
 		}
 
-		addr = (uint)(pframe);
+		addr = (__kernel_size_t)(pframe);
 		
 		mem_start = (unsigned char *)RND4(addr) + TXDESC_OFFSET;
 		_rtw_memcpy(mem_start, pbuf_start + TXDESC_OFFSET, pattrib->hdrlen);		
Index: rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/rtl8192cu_recv.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/hal/rtl8192c/usb/rtl8192cu_recv.c
+++ rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/rtl8192cu_recv.c
@@ -65,7 +65,7 @@ int	rtw_init_recv_priv(struct recv_priv
 	_rtw_memset(precvpriv->pallocated_recv_buf, 0, NR_RECVBUFF *sizeof(struct recv_buf) + 4);
 
 	precvpriv->precv_buf = precvpriv->pallocated_recv_buf + 4 -
-							((uint) (precvpriv->pallocated_recv_buf) &(4-1));
+							((__kernel_size_t) (precvpriv->pallocated_recv_buf) &(4-1));
 
 
 	precvbuf = (struct recv_buf*)precvpriv->precv_buf;
@@ -148,7 +148,7 @@ int	rtw_init_recv_priv(struct recv_priv
 			{
 				pskb->dev = padapter->pnetdev;
 
-				tmpaddr = (u32)pskb->data;
+				tmpaddr = (__kernel_size_t)pskb->data;
 				alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
 				skb_reserve(pskb, (RECVBUFF_ALIGN_SZ - alignment));
 
Index: rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/rtl8192cu_xmit.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/hal/rtl8192c/usb/rtl8192cu_xmit.c
+++ rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/rtl8192cu_xmit.c
@@ -1064,7 +1064,7 @@ void rtw_dump_xframe(_adapter *padapter,
 
 		mem_addr += w_sz;
 
-		mem_addr = (u8 *)RND4(((uint)(mem_addr)));
+		mem_addr = (u8 *)RND4(((__kernel_size_t)(mem_addr)));
 
 	}
 	
Index: rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/usb_ops_linux.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/hal/rtl8192c/usb/usb_ops_linux.c
+++ rtl8192CU_linux_v2.0.1126.20101020/hal/rtl8192c/usb/usb_ops_linux.c
@@ -73,7 +73,7 @@ static int usbctrl_vendorreq(struct dvob
 		return(-1);
 	}
 	
-	pIo_buf = palloc_buf + 16 -((uint)(palloc_buf) & 0x0f );
+	pIo_buf = palloc_buf + 16 -((__kernel_size_t)(palloc_buf) & 0x0f );
 	
 		
 	if (requesttype == 0x01)
@@ -660,7 +660,7 @@ static int recvbuf2recvframe(_adapter *p
 
 		if(pkt_copy)
 		{					
-			tmpaddr = (u32)pkt_copy->data;	
+			tmpaddr = (__kernel_size_t)pkt_copy->data;
 			alignment = tmpaddr & (3);			
 			skb_reserve(pkt_copy, (4 - alignment));//force pkt_copy->data at 4-byte alignment address
 			
@@ -744,7 +744,11 @@ void rtl8192cu_recv_tasklet(void *priv)
 
 #ifdef CONFIG_PREALLOC_RECV_SKB
 
-		pskb->tail = pskb->data;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+                pskb->tail = (sk_buff_data_t)(pskb->data - pskb->head);
+#else
+                pskb->tail = (sk_buff_data_t)(pskb->data);
+#endif
 		pskb->len = 0;
 		
 		skb_queue_tail(&precvpriv->free_recv_skb_queue, pskb);
@@ -909,14 +913,19 @@ _func_enter_;
 				return _FAIL;
 			}	
 
-			tmpaddr = (u32)precvbuf->pskb->data;
+			tmpaddr = (__kernel_size_t)precvbuf->pskb->data;
 	        	alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
 	       	        skb_reserve(precvbuf->pskb, (RECVBUFF_ALIGN_SZ - alignment));			
 
 			precvbuf->phead = precvbuf->pskb->head;
 		   	precvbuf->pdata = precvbuf->pskb->data;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+			precvbuf->ptail = precvbuf->pskb->head + precvbuf->pskb->tail;
+			precvbuf->pend = precvbuf->pskb->head+precvbuf->pskb->end;
+#else
 			precvbuf->ptail = precvbuf->pskb->tail;
 			precvbuf->pend = precvbuf->pskb->end;
+#endif
 
        		        precvbuf->pbuf = precvbuf->pskb->data;		
 		}	
@@ -924,10 +933,15 @@ _func_enter_;
 		{
 			precvbuf->phead = precvbuf->pskb->head;
 			precvbuf->pdata = precvbuf->pskb->data;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+			precvbuf->ptail = precvbuf->pskb->head + precvbuf->pskb->tail;
+			precvbuf->pend = precvbuf->pskb->head+precvbuf->pskb->end;
+#else
 			precvbuf->ptail = precvbuf->pskb->tail;
 			precvbuf->pend = precvbuf->pskb->end;
+#endif
 
-       		precvbuf->pbuf = precvbuf->pskb->data;
+       			precvbuf->pbuf = precvbuf->pskb->data;
 		
 			precvbuf->reuse = _FALSE;
 		}
Index: rtl8192CU_linux_v2.0.1126.20101020/include/osdep_service.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/osdep_service.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/osdep_service.h
@@ -156,7 +156,7 @@ __inline static void _init_timer(_timer
 {
 	//setup_timer(ptimer, pfunc,(u32)cntx);	
 	ptimer->function = pfunc;
-	ptimer->data = (u32)cntx;
+	ptimer->data = (__kernel_size_t)cntx;
 	init_timer(ptimer);
 }
 
Index: rtl8192CU_linux_v2.0.1126.20101020/include/rtw_recv.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/rtw_recv.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/rtw_recv.h
@@ -426,7 +426,7 @@ __inline static union recv_frame *rxmem_
 	//from any given member of recv_frame.
 	// rxmem indicates the any member/address in recv_frame
 	
-	return (union recv_frame*)(((uint)rxmem>>RXFRAME_ALIGN) <<RXFRAME_ALIGN) ;
+	return (union recv_frame*)(((__kernel_size_t)rxmem>>RXFRAME_ALIGN) <<RXFRAME_ALIGN) ;
 	
 }
 
Index: rtl8192CU_linux_v2.0.1126.20101020/include/wifi.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/wifi.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/wifi.h
@@ -270,29 +270,29 @@ enum WIFI_REG_DOMAIN {
 		*(unsigned short *)(pbuf) |= cpu_to_le16(type); \
 	} while(0)
 
-#define GetSequence(pbuf)	(cpu_to_le16(*(unsigned short *)((unsigned int)(pbuf) + 22)) >> 4)
+#define GetSequence(pbuf)	(cpu_to_le16(*(unsigned short *)((__kernel_size_t)(pbuf) + 22)) >> 4)
 
-#define GetFragNum(pbuf)	(cpu_to_le16(*(unsigned short *)((unsigned int)(pbuf) + 22)) & 0x0f)
+#define GetFragNum(pbuf)	(cpu_to_le16(*(unsigned short *)((__kernel_size_t)(pbuf) + 22)) & 0x0f)
 
-#define GetTupleCache(pbuf)	(cpu_to_le16(*(unsigned short *)((unsigned int)(pbuf) + 22)))
+#define GetTupleCache(pbuf)	(cpu_to_le16(*(unsigned short *)((__kernel_size_t)(pbuf) + 22)))
 
 #define SetFragNum(pbuf, num) \
 	do {    \
-		*(unsigned short *)((unsigned int)(pbuf) + 22) = \
-			((*(unsigned short *)((unsigned int)(pbuf) + 22)) & le16_to_cpu(~(0x000f))) | \
+		*(unsigned short *)((__kernel_size_t)(pbuf) + 22) = \
+			((*(unsigned short *)((__kernel_size_t)(pbuf) + 22)) & le16_to_cpu(~(0x000f))) | \
 			cpu_to_le16(0x0f & (num));     \
 	} while(0)
 
 #define SetSeqNum(pbuf, num) \
 	do {    \
-		*(unsigned short *)((unsigned int)(pbuf) + 22) = \
-			((*(unsigned short *)((unsigned int)(pbuf) + 22)) & le16_to_cpu((unsigned short)~0xfff0)) | \
+		*(unsigned short *)((__kernel_size_t)(pbuf) + 22) = \
+			((*(unsigned short *)((__kernel_size_t)(pbuf) + 22)) & le16_to_cpu((unsigned short)~0xfff0)) | \
 			le16_to_cpu((unsigned short)(0xfff0 & (num << 4))); \
 	} while(0)
 
 #define SetDuration(pbuf, dur) \
 	do {    \
-		*(unsigned short *)((unsigned int)(pbuf) + 2) = cpu_to_le16(0xffff & (dur)); \
+		*(unsigned short *)((__kernel_size_t)(pbuf) + 2) = cpu_to_le16(0xffff & (dur)); \
 	} while(0)
 
 
@@ -317,17 +317,17 @@ enum WIFI_REG_DOMAIN {
 		*(unsigned short *)(pbuf) |= cpu_to_le16( (amsdu & 1) << 7); \
 	} while(0)	
 
-#define GetAid(pbuf)	(cpu_to_le16(*(unsigned short *)((unsigned int)(pbuf) + 2)) & 0x3fff)
+#define GetAid(pbuf)	(cpu_to_le16(*(unsigned short *)((__kernel_size_t)(pbuf) + 2)) & 0x3fff)
 
-#define GetTid(pbuf)	(cpu_to_le16(*(unsigned short *)((unsigned int)(pbuf) + (((GetToDs(pbuf)<<1)|GetFrDs(pbuf))==3?30:24))) & 0x000f)
+#define GetTid(pbuf)	(cpu_to_le16(*(unsigned short *)((__kernel_size_t)(pbuf) + (((GetToDs(pbuf)<<1)|GetFrDs(pbuf))==3?30:24))) & 0x000f)
 
-#define GetAddr1Ptr(pbuf)	((unsigned char *)((unsigned int)(pbuf) + 4))
+#define GetAddr1Ptr(pbuf)	((unsigned char *)((__kernel_size_t)(pbuf) + 4))
 
-#define GetAddr2Ptr(pbuf)	((unsigned char *)((unsigned int)(pbuf) + 10))
+#define GetAddr2Ptr(pbuf)	((unsigned char *)((__kernel_size_t)(pbuf) + 10))
 
-#define GetAddr3Ptr(pbuf)	((unsigned char *)((unsigned int)(pbuf) + 16))
+#define GetAddr3Ptr(pbuf)	((unsigned char *)((__kernel_size_t)(pbuf) + 16))
 
-#define GetAddr4Ptr(pbuf)	((unsigned char *)((unsigned int)(pbuf) + 24))
+#define GetAddr4Ptr(pbuf)	((unsigned char *)((__kernel_size_t)(pbuf) + 24))
 
 #define MacAddr_isBcst(addr) \
 ( \
Index: rtl8192CU_linux_v2.0.1126.20101020/autoconf_rtl8192c_usb_linux.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/autoconf_rtl8192c_usb_linux.h
+++ rtl8192CU_linux_v2.0.1126.20101020/autoconf_rtl8192c_usb_linux.h
@@ -53,7 +53,7 @@
 #define CONFIG_AUTOSUSPEND	1
 #define SUPPORT_HW_RFOFF_DETECTED	1
 
-
+#define CONFIG_SKB_COPY 1
 
 #ifdef PLATFORM_LINUX
 //	#define CONFIG_PROC_DEBUG 1
Index: rtl8192CU_linux_v2.0.1126.20101020/core/rtw_sta_mgt.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/core/rtw_sta_mgt.c
+++ rtl8192CU_linux_v2.0.1126.20101020/core/rtw_sta_mgt.c
@@ -79,7 +79,7 @@ _func_enter_;
 		return _FAIL;
 
 	pstapriv->pstainfo_buf = pstapriv->pallocated_stainfo_buf + 4 - 
-		((unsigned int)(pstapriv->pallocated_stainfo_buf ) & 3);
+		((__kernel_size_t)(pstapriv->pallocated_stainfo_buf ) & 3);
 
 	_rtw_init_queue(&pstapriv->free_sta_queue);
 
Index: rtl8192CU_linux_v2.0.1126.20101020/include/autoconf.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/autoconf.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/autoconf.h
@@ -53,7 +53,7 @@
 #define CONFIG_AUTOSUSPEND	1
 #define SUPPORT_HW_RFOFF_DETECTED	1
 
-
+#define CONFIG_SKB_COPY 1
 
 #ifdef PLATFORM_LINUX
 //	#define CONFIG_PROC_DEBUG 1
Index: rtl8192CU_linux_v2.0.1126.20101020/include/basic_types.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/basic_types.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/basic_types.h
@@ -99,7 +99,7 @@
 	typedef void (*proc_t)(void*);
 
 	typedef 	__kernel_size_t	SIZE_T;	
-	#define FIELD_OFFSET(s,field)	((int)&((s*)(0))->field)
+	#define FIELD_OFFSET(s,field)	((__kernel_size_t)&((s*)(0))->field)
 	
 #endif
 
Index: rtl8192CU_linux_v2.0.1126.20101020/os_dep/linux/recv_linux.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/os_dep/linux/recv_linux.c
+++ rtl8192CU_linux_v2.0.1126.20101020/os_dep/linux/recv_linux.c
@@ -224,7 +224,11 @@ _func_enter_;
 	RT_TRACE(_module_recv_osdep_c_,_drv_info_,("precv_frame->hdr.rx_tail=%p precv_frame->u.hdr.rx_end=%p precv_frame->hdr.len=%d \n", precv_frame->u.hdr.rx_tail, precv_frame->u.hdr.rx_end, precv_frame->u.hdr.len));
 		
 	skb->data = precv_frame->u.hdr.rx_data;
-	skb->tail = precv_frame->u.hdr.rx_tail;	
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	skb->tail = (sk_buff_data_t) (precv_frame->u.hdr.rx_tail-precv_frame->u.hdr.rx_head);
+#else
+	skb->tail = (sk_buff_data_t)(precv_frame->u.hdr.rx_tail);
+#endif
 	skb->len = precv_frame->u.hdr.len;
 	
 	RT_TRACE(_module_recv_osdep_c_,_drv_info_,("\n skb->head=%p skb->data=%p skb->tail=%p skb->end=%p skb->len=%d\n", skb->head, skb->data, skb->tail, skb->end, skb->len));
Index: rtl8192CU_linux_v2.0.1126.20101020/os_dep/linux/xmit_linux.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/os_dep/linux/xmit_linux.c
+++ rtl8192CU_linux_v2.0.1126.20101020/os_dep/linux/xmit_linux.c
@@ -40,7 +40,7 @@
 
 uint rtw_remainder_len(struct pkt_file *pfile)
 {
-	return (pfile->buf_len - ((u32)(pfile->cur_addr) - (u32)(pfile->buf_start)));
+	return (pfile->buf_len - ((__kernel_size_t)(pfile->cur_addr) - (__kernel_size_t)(pfile->buf_start)));
 }
 
 void _rtw_open_pktfile (_pkt *pktptr, struct pkt_file *pfile)
Index: rtl8192CU_linux_v2.0.1126.20101020/os_dep/osdep_service.c
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/os_dep/osdep_service.c
+++ rtl8192CU_linux_v2.0.1126.20101020/os_dep/osdep_service.c
@@ -289,7 +289,7 @@ void	_rtw_rwlock_init(_rwlock *prwlock)
 {
 #ifdef PLATFORM_LINUX
 
-	init_MUTEX(prwlock);
+	sema_init(prwlock, 1);
 
 #endif
 #ifdef PLATFORM_OS_XP
Index: rtl8192CU_linux_v2.0.1126.20101020/include/rtl8712_recv.h
===================================================================
--- rtl8192CU_linux_v2.0.1126.20101020.orig/include/rtl8712_recv.h
+++ rtl8192CU_linux_v2.0.1126.20101020/include/rtl8712_recv.h
@@ -193,8 +193,13 @@ struct recv_buf{
 	uint  len;	
 	u8 *phead;
 	u8 *pdata;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	uint ptail;
+	uint ptail
+#else
 	u8 *ptail;
 	u8 *pend;
+#endif
 	
 	u8 *pbuf;	
 	u8 *pallocated_buf;

--------------090201000108000304030307--
