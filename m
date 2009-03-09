Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:55544 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZCIIhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 04:37:16 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1554976rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 01:37:14 -0700 (PDT)
Message-ID: <49B4D53A.60801@gmail.com> (sfid-20090309_093723_658671_10C69017)
Date: Mon, 09 Mar 2009 01:37:14 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com
Subject: [PATCH] strip: checkpatch.pl cleanups
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

strip: checkpatch.pl cleanups

Before: 110 errors, 135 warnings, 2800 lines checked
After:  8 errors, 134 warnings, 2800 lines checked

Most fixes were "return is not a function, parenthesis are not
required", trailing whitespace, and "spaces required around 'x'"

md5sums before and after are identical.

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 7015f24..88e6828 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -22,27 +22,27 @@
  *        New byte stuffing (2+6 run-length encoding)
  *        New watchdog timer task
  *        New Protocol key (SIP0)
- *        
+ *
  *        v0.9.1 3rd March 1996 (SC)
  *        Changed to dynamic device allocation -- no more compile
  *        time (or boot time) limit on the number of STRIP devices.
- *        
+ *
  *        v0.9.2 13th March 1996 (SC)
  *        Uses arp cache lookups (but doesn't send arp packets yet)
- *        
+ *
  *        v0.9.3 17th April 1996 (SC)
  *        Fixed bug where STR_ERROR flag was getting set unneccessarily
  *        (causing otherwise good packets to be unneccessarily dropped)
- *        
+ *
  *        v0.9.4 27th April 1996 (SC)
  *        First attempt at using "&COMMAND" Starmode AT commands
- *        
+ *
  *        v0.9.5 29th May 1996 (SC)
  *        First attempt at sending (unicast) ARP packets
- *        
+ *
  *        v0.9.6 5th June 1996 (Elliot)
  *        Put "message level" tags in every "printk" statement
- *        
+ *
  *        v0.9.7 13th June 1996 (laik)
  *        Added support for the /proc fs
  *
@@ -298,7 +298,7 @@ struct strip {
 
 /*
  * Note: manual_dev_addr hack
- *
+ *
  * It is not possible to change the hardware address of a Metricom radio,
  * or to send packets with a user-specified hardware source address, thus
  * trying to manually set a hardware source address is a questionable
@@ -315,22 +315,22 @@ struct strip {
  * machine. This allows you to connect a pair of radios to one machine,
  * and to use one exclusively for inbound traffic, and the other
  * exclusively for outbound traffic. Pretty neat, huh?
- *
+ *
  * Here's the full procedure to set this up:
- *
+ *
  * 1. "slattach" two interfaces, e.g. st0 for outgoing packets,
  *    and st1 for incoming packets
- *
+ *
  * 2. "ifconfig" st0 (outbound radio) to have the hardware address
  *    which is the real hardware address of st1 (inbound radio).
  *    Now when it sends out packets, it will masquerade as st1, and
  *    replies will be sent to that radio, which is exactly what we want.
- *
+ *
  * 3. Set the route table entry ("route add default ..." or
  *    "route add -net ...", as appropriate) to send packets via the st0
  *    interface (outbound radio). Do not add any route which sends packets
  *    out via the st1 interface -- that radio is for inbound traffic only.
- *
+ *
  * 4. "ifconfig" st1 (inbound radio) to have hardware address zero.
  *    This tells the STRIP driver to "shut down" that interface and not
  *    send any packets through it. In particular, it stops sending the
@@ -345,17 +345,17 @@ struct strip {
  *    st0, and if it sees the reply come from st1 then it will ignore
  *    it (to be accurate, it puts the entry in the ARP table, but
  *    labelled in such a way that st0 can't use it).
- *
+ *
  * Thanks to Petros Maniatis for coming up with the idea of splitting
  * inbound and outbound traffic between two interfaces, which turned
  * out to be really easy to implement, even if it is a bit of a hack.
- *
+ *
  * Having set a manual address on an interface, you can restore it
  * to automatic operation (where the address is automatically kept
  * consistent with the real address of the radio) by setting a manual
  * address of all ones, e.g. "ifconfig st0 hw strip FFFFFFFFFFFF"
  * This 'turns off' manual override mode for the device address.
- *
+ *
  * Note: The IEEE 802 headers reported in tcpdump will show the *real*
  * radio addresses the packets were sent and received from, so that you
  * can see what is really going on with packets, and which interfaces
@@ -369,7 +369,7 @@ struct strip {
 /*
  * CommandString1 works on all radios
  * Other CommandStrings are only used with firmware that provides
structured responses.
- *
+ *
  * ats319=1 Enables Info message for node additions and deletions
  * ats319=2 Enables Info message for a new best node
  * ats319=4 Enables checksums
@@ -407,8 +407,8 @@ static const StringDescriptor CommandString[] = {
 static const char hextable[16] = "0123456789ABCDEF";
 
 static const MetricomAddress zero_address;
-static const MetricomAddress broadcast_address =
-    { {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF} };
+static const MetricomAddress broadcast_address = {
+    {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF} };
 
 static const MetricomKey SIP0Key = { "SIP0" };
 static const MetricomKey ARP0Key = { "ARP0" };
@@ -443,18 +443,18 @@ static DEFINE_SPINLOCK(strip_lock);
 /* Macros                                */
 
 /* Returns TRUE if text T begins with prefix P */
-#define has_prefix(T,L,P) (((L) >= sizeof(P)-1) && !strncmp((T), (P),
sizeof(P)-1))
+#define has_prefix(T, L, P) (((L) >= sizeof(P)-1) && !strncmp((T), (P),
sizeof(P)-1))
 
 /* Returns TRUE if text T of length L is equal to string S */
-#define text_equal(T,L,S) (((L) == sizeof(S)-1) && !strncmp((T), (S),
sizeof(S)-1))
+#define text_equal(T, L, S) (((L) == sizeof(S)-1) && !strncmp((T), (S),
sizeof(S)-1))
 
-#define READHEX(X) ((X)>='0' && (X)<='9' ? (X)-'0' :      \
-                    (X)>='a' && (X)<='f' ? (X)-'a'+10 :   \
-                    (X)>='A' && (X)<='F' ? (X)-'A'+10 : 0 )
+#define READHEX(X) ((X) >= '0' && (X) <= '9' ? (X)-'0' :      \
+            (X) >= 'a' && (X) <= 'f' ? (X)-'a'+10 :   \
+            (X) >= 'A' && (X) <= 'F' ? (X)-'A'+10 : 0)
 
 #define READHEX16(X) ((__u16)(READHEX(X)))
 
-#define READDEC(X) ((X)>='0' && (X)<='9' ? (X)-'0' : 0)
+#define READDEC(X) ((X) >= '0' && (X) <= '9' ? (X)-'0' : 0)
 
 #define ARRAY_END(X) (&((X)[ARRAY_SIZE(X)]))
 
@@ -484,7 +484,7 @@ static int arp_query(unsigned char *haddr, u32 paddr,
 }
 
 static void DumpData(char *msg, struct strip *strip_info, __u8 * ptr,
-             __u8 * end)
+             __u8 *end)
 {
     static const int MAX_DumpData = 80;
     __u8 pkt_text[MAX_DumpData], *p = pkt_text;
@@ -554,15 +554,15 @@ typedef enum {
 #define StuffData_FinishBlock(X) \
 (*code_ptr = (X) ^ Stuff_Magic, code = Stuff_NoCode)
 
-static __u8 *StuffData(__u8 * src, __u32 length, __u8 * dst,
-               __u8 ** code_ptr_ptr)
+static __u8 *StuffData(__u8 *src, __u32 length, __u8 *dst,
+               __u8 **code_ptr_ptr)
 {
     __u8 *end = src + length;
     __u8 *code_ptr = *code_ptr_ptr;
     __u8 code = Stuff_NoCode, count = 0;
 
     if (!length)
-        return (dst);
+        return dst;
 
     if (code_ptr) {
         /*
@@ -620,7 +620,7 @@ static __u8 *StuffData(__u8 * src, __u32 length,
__u8 * dst,
             /* else, we only have one so far, so switch to Stuff_Diff
code */
             code = Stuff_Diff;
             /* and fall through to Stuff_Diff case below
-             * Note cunning cleverness here: case Stuff_Diff compares
+             * Note cunning cleverness here: case Stuff_Diff compares
              * the current character with the previous two to see if it
              * has a run of three the same. Won't this be an error if
              * there aren't two previous characters stored to compare with?
@@ -669,7 +669,7 @@ static __u8 *StuffData(__u8 * src, __u32 length,
__u8 * dst,
         *code_ptr_ptr = code_ptr;
         StuffData_FinishBlock(code + count);
     }
-    return (dst);
+    return dst;
 }
 
 /*
@@ -677,7 +677,7 @@ static __u8 *StuffData(__u8 * src, __u32 length,
__u8 * dst,
  * It writes the decoded data into the buffer pointed to by "dst", up to a
  * maximum of "dst_length", and returns the new value of "src" so that a
  * follow-on call can read more data, continuing from where the first
left off.
- *
+ *
  * There are three types of results:
  * 1. The source data runs out before extracting "dst_length" bytes:
  *    UnStuffData returns NULL to indicate failure.
@@ -686,7 +686,7 @@ static __u8 *StuffData(__u8 * src, __u32 length,
__u8 * dst,
  * 3. "dst_length" bytes are extracted, with more remaining.
  *    UnStuffData returns new_src < end to indicate that there are more
bytes
  *    to be read.
- *
+ *
  * Note: The decoding may be destructive, in that it may alter the source
  * data in the process of decoding it (this is necessary to allow a
follow-on
  * call to resume correctly).
@@ -698,13 +698,13 @@ static __u8 *UnStuffData(__u8 * src, __u8 * end,
__u8 * dst,
     __u8 *dst_end = dst + dst_length;
     /* Sanity check */
     if (!src || !end || !dst || !dst_length)
-        return (NULL);
+        return NULL;
     while (src < end && dst < dst_end) {
         int count = (*src ^ Stuff_Magic) & Stuff_CountMask;
         switch ((*src ^ Stuff_Magic) & Stuff_CodeMask) {
         case Stuff_Diff:
             if (src + 1 + count >= end)
-                return (NULL);
+                return NULL;
             do {
                 *dst++ = *++src ^ Stuff_Magic;
             }
@@ -722,7 +722,7 @@ static __u8 *UnStuffData(__u8 * src, __u8 * end,
__u8 * dst,
             break;
         case Stuff_DiffZero:
             if (src + 1 + count >= end)
-                return (NULL);
+                return NULL;
             do {
                 *dst++ = *++src ^ Stuff_Magic;
             }
@@ -735,7 +735,7 @@ static __u8 *UnStuffData(__u8 * src, __u8 * end,
__u8 * dst,
             break;
         case Stuff_Same:
             if (src + 1 >= end)
-                return (NULL);
+                return NULL;
             do {
                 *dst++ = src[1] ^ Stuff_Magic;
             }
@@ -758,9 +758,9 @@ static __u8 *UnStuffData(__u8 * src, __u8 * end,
__u8 * dst,
         }
     }
     if (dst < dst_end)
-        return (NULL);
+        return NULL;
     else
-        return (src);
+        return src;
 }
 
 
@@ -775,7 +775,7 @@ static void set_baud(struct tty_struct *tty, speed_t
baudrate)
     struct ktermios old_termios;
 
     mutex_lock(&tty->termios_mutex);
-    old_termios =*(tty->termios);
+    old_termios = *(tty->termios);
     tty_encode_baud_rate(tty, baudrate, baudrate);
     tty->ops->set_termios(tty, &old_termios);
     mutex_unlock(&tty->termios_mutex);
@@ -788,31 +788,31 @@ static void set_baud(struct tty_struct *tty,
speed_t baudrate)
 #define IS_RADIO_ADDRESS(p)
(                                                 \
   isdigit((p)[0]) && isdigit((p)[1]) && isdigit((p)[2]) &&
isdigit((p)[3]) && \
   (p)[4] == '-'
&&                                                            \
-  isdigit((p)[5]) && isdigit((p)[6]) && isdigit((p)[7]) &&
isdigit((p)[8])    )
+  isdigit((p)[5]) && isdigit((p)[6]) && isdigit((p)[7]) && isdigit((p)[8]))
 
-static int string_to_radio_address(MetricomAddress * addr, __u8 * p)
+static int string_to_radio_address(MetricomAddress *addr, __u8 *p)
 {
     if (!IS_RADIO_ADDRESS(p))
-        return (1);
+        return 1;
     addr->c[0] = 0;
     addr->c[1] = 0;
     addr->c[2] = READHEX(p[0]) << 4 | READHEX(p[1]);
     addr->c[3] = READHEX(p[2]) << 4 | READHEX(p[3]);
     addr->c[4] = READHEX(p[5]) << 4 | READHEX(p[6]);
     addr->c[5] = READHEX(p[7]) << 4 | READHEX(p[8]);
-    return (0);
+    return 0;
 }
 
 /*
  * Convert a Metricom Address to a string.
  */
 
-static __u8 *radio_address_to_string(const MetricomAddress * addr,
-                     MetricomAddressString * p)
+static __u8 *radio_address_to_string(const MetricomAddress *addr,
+                     MetricomAddressString *p)
 {
     sprintf(p->c, "%02X%02X-%02X%02X", addr->c[2], addr->c[3],
         addr->c[4], addr->c[5]);
-    return (p->c);
+    return p->c;
 }
 
 /*
@@ -836,16 +836,16 @@ static int allocate_buffers(struct strip
*strip_info, int mtu)
         strip_info->sx_size = sx_size;
         strip_info->tx_size = tx_size;
         strip_info->mtu = dev->mtu = mtu;
-        return (1);
+        return 1;
     }
     kfree(r);
     kfree(s);
     kfree(t);
-    return (0);
+    return 0;
 }
 
 /*
- * MTU has been changed by the IP layer.
+ * MTU has been changed by the IP layer.
  * We could be in
  * an upcall from the tty driver, or in an ip packet queue.
  */
@@ -928,15 +928,15 @@ static char *time_delta(char buffer[], long time)
 {
     time -= jiffies;
     if (time > LongTime / 2)
-        return ("Not scheduled");
+        return "Not scheduled";
     if (time < 0)
         time = 0;    /* Don't print negative times */
     sprintf(buffer, "%ld seconds", time / HZ);
-    return (buffer);
+    return buffer;
 }
 
 /* get Nth element of the linked list */
-static struct strip *strip_get_idx(loff_t pos)
+static struct strip *strip_get_idx(loff_t pos)
 {
     struct strip *str;
     int i = 0;
@@ -978,7 +978,7 @@ static void strip_seq_stop(struct seq_file *seq,
void *v)
 }
 
 static void strip_seq_neighbours(struct seq_file *seq,
-               const MetricomNodeTable * table,
+               const MetricomNodeTable *table,
                const char *title)
 {
     /* We wrap this in a do/while loop, so if the table changes */
@@ -1005,14 +1005,14 @@ static void strip_seq_neighbours(struct seq_file
*seq,
 /*
  * This function prints radio status information via the seq_file
  * interface.  The interface takes care of buffer size and over
- * run issues.
+ * run issues.
  *
- * The buffer in seq_file is PAGESIZE (4K)
+ * The buffer in seq_file is PAGESIZE (4K)
  * so this routine should never print more or it will get truncated.
  * With the maximum of 32 portables and 32 poletops
  * reported, the routine outputs 3107 bytes into the buffer.
  */
-static void strip_seq_status_info(struct seq_file *seq,
+static void strip_seq_status_info(struct seq_file *seq,
                   const struct strip *strip_info)
 {
     char temp[32];
@@ -1157,7 +1157,7 @@ static void ResetRadio(struct strip *strip_info)
     static const char init[] = "ate0q1dt**starmode\r**";
     StringDescriptor s = { init, sizeof(init) - 1 };
 
-    /*
+    /*
      * If the radio isn't working anymore,
      * we should clear the old status information.
      */
@@ -1182,7 +1182,7 @@ static void ResetRadio(struct strip *strip_info)
     strip_info->sx_average_pps = 0;
 
     /* Mark radio address as unknown */
-    *(MetricomAddress *) & strip_info->true_dev_addr = zero_address;
+    *(MetricomAddress *) &strip_info->true_dev_addr = zero_address;
     if (!strip_info->manual_dev_addr)
         *(MetricomAddress *) strip_info->dev->dev_addr =
             zero_address;
@@ -1294,14 +1294,14 @@ static unsigned char *strip_make_packet(unsigned
char *buffer,
         printk(KERN_ERR
                "%s: strip_make_packet: Unknown packet type 0x%04X\n",
                strip_info->dev->name, ntohs(header->protocol));
-        return (NULL);
+        return NULL;
     }
 
     if (len > strip_info->mtu) {
         printk(KERN_ERR
                "%s: Dropping oversized transmit packet: %d bytes\n",
                strip_info->dev->name, len);
-        return (NULL);
+        return NULL;
     }
 
     /*
@@ -1311,7 +1311,7 @@ static unsigned char *strip_make_packet(unsigned
char *buffer,
     if (!memcmp(haddr.c, strip_info->true_dev_addr.c, sizeof(haddr))) {
         printk(KERN_ERR "%s: Dropping packet addressed to self\n",
                strip_info->dev->name);
-        return (NULL);
+        return NULL;
     }
 
     /*
@@ -1337,7 +1337,7 @@ static unsigned char *strip_make_packet(unsigned
char *buffer,
             printk(KERN_ERR
                    "%s: Unable to send packet (no broadcast hub
configured)\n",
                    strip_info->dev->name);
-            return (NULL);
+            return NULL;
         }
         /*
          * If we are the broadcast hub, don't bother sending to ourselves.
@@ -1345,7 +1345,7 @@ static unsigned char *strip_make_packet(unsigned
char *buffer,
          */
         if (!memcmp
             (haddr.c, strip_info->true_dev_addr.c, sizeof(haddr)))
-            return (NULL);
+            return NULL;
     }
 
     *ptr++ = 0x0D;
@@ -1373,7 +1373,7 @@ static unsigned char *strip_make_packet(unsigned
char *buffer,
         ptr = add_checksum(buffer + 1, ptr);
 
     *ptr++ = 0x0D;
-    return (ptr);
+    return ptr;
 }
 
 static void strip_send(struct strip *strip_info, struct sk_buff *skb)
@@ -1538,7 +1538,7 @@ static int strip_xmit(struct sk_buff *skb, struct
net_device *dev)
     if (!netif_running(dev)) {
         printk(KERN_ERR "%s: xmit call when iface is down\n",
                dev->name);
-        return (1);
+        return 1;
     }
 
     netif_stop_queue(dev);
@@ -1621,10 +1621,10 @@ static int strip_header(struct sk_buff *skb,
struct net_device *dev,
     /*HexDump("strip_header", netdev_priv(dev), skb->data, skb->data +
skb->len); */
 
     if (!daddr)
-        return (-dev->hard_header_len);
+        return -dev->hard_header_len;
 
     header->dst_addr = *(MetricomAddress *) daddr;
-    return (dev->hard_header_len);
+    return dev->hard_header_len;
 }
 
 /*
@@ -1724,7 +1724,7 @@ static void get_radio_voltage(struct strip
*strip_info, __u8 * ptr, __u8 * end)
  * This function parses the responses to the AT~LA and ATS311 commands,
  * which list the radio's neighbours.
  */
-static void get_radio_neighbours(MetricomNodeTable * table, __u8 * ptr,
__u8 * end)
+static void get_radio_neighbours(MetricomNodeTable *table, __u8 *ptr,
__u8 *end)
 {
     table->num_nodes = 0;
     while (ptr < end && table->num_nodes < NODE_TABLE_SIZE) {
@@ -1746,7 +1746,7 @@ static int get_radio_address(struct strip
*strip_info, __u8 * p)
     MetricomAddress addr;
 
     if (string_to_radio_address(&addr, p))
-        return (1);
+        return 1;
 
     /* See if our radio address has changed */
     if (memcmp(strip_info->true_dev_addr.c, addr.c, sizeof(addr))) {
@@ -1762,7 +1762,7 @@ static int get_radio_address(struct strip
*strip_info, __u8 * p)
         strip_info->gratuitous_arp = jiffies + 15 * HZ;
         strip_info->arp_interval = 1 * HZ;
     }
-    return (0);
+    return 0;
 }
 
 static int verify_checksum(struct strip *strip_info)
@@ -1790,8 +1790,8 @@ static void RecvErr(char *msg, struct strip
*strip_info)
     strip_info->rx_errors++;
 }
 
-static void RecvErr_Message(struct strip *strip_info, __u8 * sendername,
-                const __u8 * msg, u_long len)
+static void RecvErr_Message(struct strip *strip_info, __u8 *sendername,
+                const __u8 *msg, u_long len)
 {
     if (has_prefix(msg, len, "001")) {    /* Not in StarMode! */
         RecvErr("Error Msg:", strip_info);
@@ -1889,8 +1889,8 @@ static void RecvErr_Message(struct strip
*strip_info, __u8 * sendername,
         RecvErr("Error Msg:", strip_info);
 }
 
-static void process_AT_response(struct strip *strip_info, __u8 * ptr,
-                __u8 * end)
+static void process_AT_response(struct strip *strip_info, __u8 *ptr,
+                __u8 *end)
 {
     u_long len;
     __u8 *p = ptr;
@@ -1956,12 +1956,12 @@ static struct net_device *get_strip_dev(struct
strip *strip_info)
                        "%s: Transferred packet ownership to %s.\n",
                        strip_info->dev->name, dev->name);
                 read_unlock_bh(&dev_base_lock);
-                return (dev);
+                return dev;
             }
         }
         read_unlock_bh(&dev_base_lock);
     }
-    return (strip_info->dev);
+    return strip_info->dev;
 }
 
 /*
@@ -2001,8 +2001,8 @@ static void deliver_packet(struct strip
*strip_info, STRIP_Header * header,
 }
 
 static void process_IP_packet(struct strip *strip_info,
-                  STRIP_Header * header, __u8 * ptr,
-                  __u8 * end)
+                  STRIP_Header *header, __u8 *ptr,
+                  __u8 *end)
 {
     __u16 packetlen;
 
@@ -2043,8 +2043,8 @@ static void process_IP_packet(struct strip
*strip_info,
 }
 
 static void process_ARP_packet(struct strip *strip_info,
-                   STRIP_Header * header, __u8 * ptr,
-                   __u8 * end)
+                   STRIP_Header *header, __u8 *ptr,
+                   __u8 *end)
 {
     __u16 packetlen;
     struct arphdr *arphdr = (struct arphdr *) strip_info->rx_buff;
@@ -2245,9 +2245,9 @@ static void process_message(struct strip *strip_info)
 }
 
 #define TTYERROR(X) ((X) == TTY_BREAK   ? "Break"            : \
-                     (X) == TTY_FRAME   ? "Framing Error"    : \
-                     (X) == TTY_PARITY  ? "Parity Error"     : \
-                     (X) == TTY_OVERRUN ? "Hardware Overrun" : "Unknown
Error")
+             (X) == TTY_FRAME   ? "Framing Error"    : \
+             (X) == TTY_PARITY  ? "Parity Error"     : \
+             (X) == TTY_OVERRUN ? "Hardware Overrun" : "Unknown Error")
 
 /*
  * Handle the 'receiver data ready' interrupt.
@@ -2341,7 +2341,7 @@ static void strip_receive_buf(struct tty_struct
*tty, const unsigned char *cp,
 /* General control routines                        */
 
 static int set_mac_address(struct strip *strip_info,
-               MetricomAddress * addr)
+               MetricomAddress *addr)
 {
     /*
      * We're using a manually specified address if the address is set
@@ -2383,7 +2383,7 @@ static struct net_device_stats
*strip_get_stats(struct net_device *dev)
     stats.tx_errors = strip_info->tx_errors;
     stats.rx_errors = strip_info->rx_errors;
     stats.rx_over_errors = strip_info->rx_over_errors;
-    return (&stats);
+    return &stats;
 }
 
 
@@ -2419,10 +2419,10 @@ static int strip_open_low(struct net_device *dev)
     struct strip *strip_info = netdev_priv(dev);
 
     if (strip_info->tty == NULL)
-        return (-ENODEV);
+        return -ENODEV;
 
     if (!allocate_buffers(strip_info, dev->mtu))
-        return (-ENOMEM);
+        return -ENOMEM;
 
     strip_info->sx_count = 0;
     strip_info->tx_left = 0;
@@ -2439,7 +2439,7 @@ static int strip_open_low(struct net_device *dev)
     strip_info->idle_timer.expires = jiffies + 1 * HZ;
     add_timer(&strip_info->idle_timer);
     netif_wake_queue(dev);
-    return (0);
+    return 0;
 }
 
 
@@ -2497,7 +2497,7 @@ static void strip_dev_setup(struct net_device *dev)
      *  netdev_priv(dev) Already holds a pointer to our struct strip
      */
 
-    *(MetricomAddress *) & dev->broadcast = broadcast_address;
+    *(MetricomAddress *) &dev->broadcast = broadcast_address;
     dev->dev_addr[0] = 0;
     dev->addr_len = sizeof(MetricomAddress);
 
@@ -2653,7 +2653,7 @@ static int strip_open(struct tty_struct *tty)
     /*
      * Done.  We have linked the TTY line to a channel.
      */
-    return (strip_info->dev->base_addr);
+    return strip_info->dev->base_addr;
 }
 
 /*
@@ -2702,14 +2702,14 @@ static int strip_ioctl(struct tty_struct *tty,
struct file *file,
 
     switch (cmd) {
     case SIOCGIFNAME:
-        if(copy_to_user((void __user *) arg, strip_info->dev->name,
strlen(strip_info->dev->name) + 1))
+        if (copy_to_user((void __user *) arg, strip_info->dev->name,
strlen(strip_info->dev->name) + 1))
             return -EFAULT;
         break;
     case SIOCSIFHWADDR:
     {
         MetricomAddress addr;
-        //printk(KERN_INFO "%s: SIOCSIFHWADDR\n", strip_info->dev->name);
-        if(copy_from_user(&addr, (void __user *) arg,
sizeof(MetricomAddress)))
+        /* printk(KERN_INFO "%s: SIOCSIFHWADDR\n",
strip_info->dev->name); */
+        if (copy_from_user(&addr, (void __user *) arg,
sizeof(MetricomAddress)))
             return -EFAULT;
         return set_mac_address(strip_info, &addr);
     }
@@ -2748,9 +2748,9 @@ static int __init strip_init_driver(void)
 {
     int status;
 
+
     printk(signon, StripVersion);
 
-    
     /*
      * Fill in our line protocol discipline, and register it
      */
@@ -2774,7 +2774,7 @@ static const char signoff[] __exitdata =
 static void __exit strip_exit_driver(void)
 {
     int i;
-    struct list_head *p,*n;
+    struct list_head *p, *n;
 
     /* module ref count rules assure that all entries are unregistered */
     list_for_each_safe(p, n, &strip_list) {
