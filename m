Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:60120 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbXIZXw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 19:52:58 -0400
Date: Wed, 26 Sep 2007 16:51:35 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20070926235135.GA16051@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <1190292526.18521.52.camel@johannes.berg> <20070920165545.GA29452@bougret.hpl.hp.com> <1190307669.18521.94.camel@johannes.berg> <20070920205602.GA15373@bougret.hpl.hp.com> <1190385414.18521.148.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190385414.18521.148.camel@johannes.berg>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2007 at 04:36:54PM +0200, Johannes Berg wrote:
> On Thu, 2007-09-20 at 13:56 -0700, Jean Tourrilhes wrote:
> 
> > 	For someone familiar with it, it's actually trivial, you just
> > have to follow the patch for Wireless Tools. But for somebody
> > unfamiliar, there is a huge learning curve.
> > 	That's classical : all the eyes are on the kernel, and nobody
> > care about userspace. We really should have more people familiar with
> > the guts of wpa_supplicant.
> 
> Oh, I'm not too bad in wpa_supplicant. But I don't know how the
> workaround you came up with works. I guess I'll have to dig into that.
> You mentioned wpa_supplicant patches, do you still have those?

	Sorry, I was distracted by some Kismet bug.
	The patch I sent to Jouni was not a wpa_supplicant, but the
Wireless Tools patch. The complete fix is across multiple Wireless
Tools versions, and mixed with other stuff, this patch highlight
clearly the changes.
	The patch probably does not have enough context to figure out
everything, but at least point in the right direction. It's
documentated, but feel free to ask questions. I also have tests
vectors that you can use on i386.
	I personally don't like much the parser used in
wpa_supplicant, and it's somewhat different from my code. You will
find it in those two functions :
		wpa_driver_wext_event_wireless()
		wpa_driver_wext_get_scan_results()
	Have fun...

	Jean

-------------------------------------------------------------

diff -u -p wireless_tools.29.pre14/iwlib.c wireless_tools.29.pre20/iwlib.c
--- wireless_tools.29.pre14/iwlib.c	2007-02-16 17:17:15.000000000 -0800
+++ wireless_tools.29.pre20/iwlib.c	2007-04-19 16:33:57.000000000 -0700
@@ -2634,17 +2634,17 @@ static const unsigned int standard_event
 
 /* Size (in bytes) of various events */
 static const int event_type_size[] = {
-	IW_EV_LCP_LEN,		/* IW_HEADER_TYPE_NULL */
+	IW_EV_LCP_PK_LEN,	/* IW_HEADER_TYPE_NULL */
 	0,
-	IW_EV_CHAR_LEN,		/* IW_HEADER_TYPE_CHAR */
+	IW_EV_CHAR_PK_LEN,	/* IW_HEADER_TYPE_CHAR */
 	0,
-	IW_EV_UINT_LEN,		/* IW_HEADER_TYPE_UINT */
-	IW_EV_FREQ_LEN,		/* IW_HEADER_TYPE_FREQ */
-	IW_EV_ADDR_LEN,		/* IW_HEADER_TYPE_ADDR */
+	IW_EV_UINT_PK_LEN,	/* IW_HEADER_TYPE_UINT */
+	IW_EV_FREQ_PK_LEN,	/* IW_HEADER_TYPE_FREQ */
+	IW_EV_ADDR_PK_LEN,	/* IW_HEADER_TYPE_ADDR */
 	0,
-	IW_EV_POINT_LEN,	/* Without variable payload */
-	IW_EV_PARAM_LEN,	/* IW_HEADER_TYPE_PARAM */
-	IW_EV_QUAL_LEN,		/* IW_HEADER_TYPE_QUAL */
+	IW_EV_POINT_PK_LEN,	/* Without variable payload */
+	IW_EV_PARAM_PK_LEN,	/* IW_HEADER_TYPE_PARAM */
+	IW_EV_QUAL_PK_LEN,	/* IW_HEADER_TYPE_QUAL */
 };
 
 /*------------------------------------------------------------------*/
@@ -2681,29 +2681,26 @@ iw_extract_event_stream(struct stream_de
   /* Don't "optimise" the following variable, it will crash */
   unsigned	cmd_index;		/* *MUST* be unsigned */
 
-  /* Unused for now. Will be later on... */
-  we_version = we_version;
-
   /* Check for end of stream */
-  if((stream->current + IW_EV_LCP_LEN) > stream->end)
+  if((stream->current + IW_EV_LCP_PK_LEN) > stream->end)
     return(0);
 
-#if DEBUG
+#ifdef DEBUG
   printf("DBG - stream->current = %p, stream->value = %p, stream->end = %p\n",
 	 stream->current, stream->value, stream->end);
 #endif
 
   /* Extract the event header (to get the event id).
    * Note : the event may be unaligned, therefore copy... */
-  memcpy((char *) iwe, stream->current, IW_EV_LCP_LEN);
+  memcpy((char *) iwe, stream->current, IW_EV_LCP_PK_LEN);
 
-#if DEBUG
+#ifdef DEBUG
   printf("DBG - iwe->cmd = 0x%X, iwe->len = %d\n",
 	 iwe->cmd, iwe->len);
 #endif
 
   /* Check invalid events */
-  if(iwe->len <= IW_EV_LCP_LEN)
+  if(iwe->len <= IW_EV_LCP_PK_LEN)
     return(-1);
 
   /* Get the type and length of that event */
@@ -2721,28 +2718,28 @@ iw_extract_event_stream(struct stream_de
     }
   if(descr != NULL)
     event_type = descr->header_type;
-  /* Unknown events -> event_type=0 => IW_EV_LCP_LEN */
+  /* Unknown events -> event_type=0 => IW_EV_LCP_PK_LEN */
   event_len = event_type_size[event_type];
   /* Fixup for earlier version of WE */
   if((we_version <= 18) && (event_type == IW_HEADER_TYPE_POINT))
     event_len += IW_EV_POINT_OFF;
 
   /* Check if we know about this event */
-  if(event_len <= IW_EV_LCP_LEN)
+  if(event_len <= IW_EV_LCP_PK_LEN)
     {
       /* Skip to next event */
       stream->current += iwe->len;
       return(2);
     }
-  event_len -= IW_EV_LCP_LEN;
+  event_len -= IW_EV_LCP_PK_LEN;
 
   /* Set pointer on data */
   if(stream->value != NULL)
     pointer = stream->value;			/* Next value in event */
   else
-    pointer = stream->current + IW_EV_LCP_LEN;	/* First value in event */
+    pointer = stream->current + IW_EV_LCP_PK_LEN;	/* First value in event */
 
-#if DEBUG
+#ifdef DEBUG
   printf("DBG - event_type = %d, event_len = %d, pointer = %p\n",
 	 event_type, event_len, pointer);
 #endif
@@ -2755,6 +2752,7 @@ iw_extract_event_stream(struct stream_de
       return(-2);
     }
   /* Fixup for WE-19 and later : pointer no longer in the stream */
+  /* Beware of alignement. Dest has local alignement, not packed */
   if((we_version > 18) && (event_type == IW_HEADER_TYPE_POINT))
     memcpy((char *) iwe + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
 	   pointer, event_len);
@@ -2768,7 +2766,7 @@ iw_extract_event_stream(struct stream_de
   if(event_type == IW_HEADER_TYPE_POINT)
     {
       /* Check the length of the payload */
-      unsigned int	extra_len = iwe->len - (event_len + IW_EV_LCP_LEN);
+      unsigned int	extra_len = iwe->len - (event_len + IW_EV_LCP_PK_LEN);
       if(extra_len > 0)
 	{
 	  /* Set pointer on variable part (warning : non aligned) */
@@ -2783,9 +2781,35 @@ iw_extract_event_stream(struct stream_de
 	      /* Those checks are actually pretty hard to trigger,
 	       * because of the checks done in the kernel... */
 
+	      unsigned int	token_len = iwe->u.data.length * descr->token_size;
+
+	      /* Ugly fixup for alignement issues.
+	       * If the kernel is 64 bits and userspace 32 bits,
+	       * we have an extra 4+4 bytes.
+	       * Fixing that in the kernel would break 64 bits userspace. */
+	      if((token_len != extra_len) && (extra_len >= 4))
+		{
+		  __u16		alt_dlen = *((__u16 *) pointer);
+		  unsigned int	alt_token_len = alt_dlen * descr->token_size;
+		  if((alt_token_len + 8) == extra_len)
+		    {
+#ifdef DEBUG
+		      printf("DBG - alt_token_len = %d\n", alt_token_len);
+#endif
+		      /* Ok, let's redo everything */
+		      pointer -= event_len;
+		      pointer += 4;
+		      /* Dest has local alignement, not packed */
+		      memcpy((char *) iwe + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
+			     pointer, event_len);
+		      pointer += event_len + 4;
+		      iwe->u.data.pointer = pointer;
+		      token_len = alt_token_len;
+		    }
+		}
+
 	      /* Discard bogus events which advertise more tokens than
 	       * what they carry... */
-	      unsigned int	token_len = iwe->u.data.length * descr->token_size;
 	      if(token_len > extra_len)
 		iwe->u.data.pointer = NULL;	/* Discard paylod */
 	      /* Check that the advertised token size is not going to
@@ -2796,7 +2820,7 @@ iw_extract_event_stream(struct stream_de
 	      /* Same for underflows... */
 	      if(iwe->u.data.length < descr->min_tokens)
 		iwe->u.data.pointer = NULL;	/* Discard paylod */
-#if DEBUG
+#ifdef DEBUG
 	      printf("DBG - extra_len = %d, token_len = %d, token = %d, max = %d, min = %d\n",
 		     extra_len, token_len, iwe->u.data.length, descr->max_tokens, descr->min_tokens);
 #endif
@@ -2811,6 +2835,25 @@ iw_extract_event_stream(struct stream_de
     }
   else
     {
+      /* Ugly fixup for alignement issues.
+       * If the kernel is 64 bits and userspace 32 bits,
+       * we have an extra 4 bytes.
+       * Fixing that in the kernel would break 64 bits userspace. */
+      if((stream->value == NULL)
+	 && ((((iwe->len - IW_EV_LCP_PK_LEN) % event_len) == 4)
+	     || ((iwe->len == 12) && ((event_type == IW_HEADER_TYPE_UINT) ||
+				      (event_type == IW_HEADER_TYPE_QUAL))) ))
+	{
+#ifdef DEBUG
+	  printf("DBG - alt iwe->len = %d\n", iwe->len - 4);
+#endif
+	  pointer -= event_len;
+	  pointer += 4;
+	  /* Beware of alignement. Dest has local alignement, not packed */
+	  memcpy((char *) iwe + IW_EV_LCP_LEN, pointer, event_len);
+	  pointer += event_len;
+	}
+
       /* Is there more value in the event ? */
       if((pointer + event_len) <= (stream->current + iwe->len))
 	/* Go to next value */
diff -u -p wireless_tools.29.pre14/iwlib.h wireless_tools.29/iwlib.h
--- wireless_tools.29.pre14/iwlib.h	2007-02-16 17:17:26.000000000 -0800
+++ wireless_tools.29/iwlib.h	2007-06-22 11:01:04.000000000 -0700
@@ -153,6 +124,36 @@ extern "C" {
 #define ARPHRD_IEEE80211 801		/* IEEE 802.11			*/
 #endif /* ARPHRD_IEEE80211 */
 
+#ifndef IW_EV_LCP_PK_LEN
+/* Size of the Event prefix when packed in stream */
+#define IW_EV_LCP_PK_LEN	(4)
+/* Size of the various events when packed in stream */
+#define IW_EV_CHAR_PK_LEN	(IW_EV_LCP_PK_LEN + IFNAMSIZ)
+#define IW_EV_UINT_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(__u32))
+#define IW_EV_FREQ_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_freq))
+#define IW_EV_PARAM_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_param))
+#define IW_EV_ADDR_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct sockaddr))
+#define IW_EV_QUAL_PK_LEN	(IW_EV_LCP_PK_LEN + sizeof(struct iw_quality))
+#define IW_EV_POINT_PK_LEN	(IW_EV_LCP_PK_LEN + 4)
+
+struct iw_pk_event
+{
+	__u16		len;			/* Real lenght of this stuff */
+	__u16		cmd;			/* Wireless IOCTL */
+	union iwreq_data	u;		/* IOCTL fixed payload */
+} __attribute__ ((packed));
+struct	iw_pk_point
+{
+  void __user	*pointer;	/* Pointer to the data  (in user space) */
+  __u16		length;		/* number of fields or size in bytes */
+  __u16		flags;		/* Optional params */
+} __attribute__ ((packed));
+
+#define IW_EV_LCP_PK2_LEN	(sizeof(struct iw_pk_event) - sizeof(union iwreq_data))
+#define IW_EV_POINT_PK2_LEN	(IW_EV_LCP_PK2_LEN + sizeof(struct iw_pk_point) - IW_EV_POINT_OFF)
+
+#endif	/* IW_EV_LCP_PK_LEN */
+
 /****************************** TYPES ******************************/
 
 /* Shortcuts */
