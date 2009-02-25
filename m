Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:17657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577AbZBYVa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2009 16:30:59 -0500
Received: by rv-out-0506.google.com with SMTP id g37so194117rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2009 13:30:57 -0800 (PST)
Message-ID: <49A5B88C.1020403@gmail.com> (sfid-20090225_223107_785850_5C5E9565)
Date: Wed, 25 Feb 2009 13:30:52 -0800
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: airo_cs: checkpatch.pl cleanups
Content-Type: multipart/mixed;
 boundary="------------010807080104060105000604"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010807080104060105000604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Keeping this one simple again.

Before: 36 errors, 6 warnings, 482 lines checked
After:  14 errors, 3 warnings, 484 lines checked

This was mainly 'trailing whitespace', a few 'over 80 character', and a couple 'spaces required' fixes.

md5sum's from before and after are identical.

John


--------------010807080104060105000604
Content-Type: text/x-diff;
 name="airo_cs_checkpatch_cleanup.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="airo_cs_checkpatch_cleanup.diff"

diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index 27696c2..31cc8f5 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -16,8 +16,8 @@
     In addition this module was derived from dummy_cs.
     The initial developer of dummy_cs is David A. Hinds
     <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
-    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.    
-    
+    are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
+
 ======================================================================*/
 
 #ifdef __IN_PCMCIA_PACKAGE__
@@ -38,7 +38,7 @@
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ds.h>
 
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/system.h>
 
 #include "airo.h"
@@ -54,7 +54,7 @@
 static int pc_debug = PCMCIA_DEBUG;
 module_param(pc_debug, int, 0);
 static char *version = "$Revision: 1.2 $";
-#define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args);
+#define DEBUG(n, args...) if (pc_debug > (n)) printk(KERN_DEBUG args);
 #else
 #define DEBUG(n, args...)
 #endif
@@ -63,7 +63,7 @@ static char *version = "$Revision: 1.2 $";
 
 MODULE_AUTHOR("Benjamin Reed");
 MODULE_DESCRIPTION("Support for Cisco/Aironet 802.11 wireless ethernet \
-                   cards.  This is the module that links the PCMCIA card \
+		   cards.  This is the module that links the PCMCIA card \
 		   with the airo module.");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340 PCMCIA cards");
@@ -76,7 +76,7 @@ MODULE_SUPPORTED_DEVICE("Aironet 4500, 4800 and Cisco 340 PCMCIA cards");
    event is received.  The config() and release() entry points are
    used to configure or release a socket, in response to card
    insertion and ejection events.  They are invoked from the airo_cs
-   event handler. 
+   event handler.
 */
 
 static int airo_config(struct pcmcia_device *link);
@@ -103,8 +103,9 @@ static void airo_detach(struct pcmcia_device *p_dev);
    by one struct pcmcia_device structure (defined in ds.h).
 
    You may not want to use a linked list for this -- for example, the
-   memory card driver uses an array of struct pcmcia_device pointers, where minor
-   device numbers are used to derive the corresponding array index.
+   memory card driver uses an array of struct pcmcia_device pointers,
+   where minor device numbers are used to derive the corresponding
+   array index.
 */
 
 /*
@@ -122,22 +123,22 @@ static void airo_detach(struct pcmcia_device *p_dev);
    device IO routines can use a flag like this to throttle IO to a
    card that is not ready to accept it.
 */
-   
+
 typedef struct local_info_t {
 	dev_node_t	node;
 	struct net_device *eth_dev;
 } local_info_t;
 
 /*======================================================================
-  
+
   airo_attach() creates an "instance" of the driver, allocating
   local data structures for one device.  The device is registered
   with Card Services.
-  
+
   The dev_link structure is initialized, but we don't actually
   configure the card at this point -- we wait until we receive a
   card insertion event.
-  
+
   ======================================================================*/
 
 static int airo_probe(struct pcmcia_device *p_dev)
@@ -150,7 +151,7 @@ static int airo_probe(struct pcmcia_device *p_dev)
 	p_dev->irq.Attributes = IRQ_TYPE_DYNAMIC_SHARING;
 	p_dev->irq.IRQInfo1 = IRQ_LEVEL_ID;
 	p_dev->irq.Handler = NULL;
-	
+
 	/*
 	  General socket configuration defaults can go here.  In this
 	  client, we assume very little, and rely on the CIS for almost
@@ -160,7 +161,7 @@ static int airo_probe(struct pcmcia_device *p_dev)
 	*/
 	p_dev->conf.Attributes = 0;
 	p_dev->conf.IntType = INT_MEMORY_AND_IO;
-	
+
 	/* Allocate space for private device-specific data */
 	local = kzalloc(sizeof(local_info_t), GFP_KERNEL);
 	if (!local) {
@@ -173,12 +174,12 @@ static int airo_probe(struct pcmcia_device *p_dev)
 } /* airo_attach */
 
 /*======================================================================
-  
+
   This deletes a driver "instance".  The device is de-registered
   with Card Services.  If it has been released, all local data
   structures are freed.  Otherwise, the structures will be freed
   when the device is released.
-  
+
   ======================================================================*/
 
 static void airo_detach(struct pcmcia_device *link)
@@ -196,11 +197,11 @@ static void airo_detach(struct pcmcia_device *link)
 } /* airo_detach */
 
 /*======================================================================
-  
+
   airo_config() is scheduled to run after a CARD_INSERTION event
   is received, to configure the PCMCIA socket, and to make the
   device available to the system.
-  
+
   ======================================================================*/
 
 #define CS_CHECK(fn, ret) \
@@ -325,18 +326,19 @@ static int airo_config(struct pcmcia_device *link)
 	*/
 	if (link->conf.Attributes & CONF_ENABLE_IRQ)
 		CS_CHECK(RequestIRQ, pcmcia_request_irq(link, &link->irq));
-	
+
 	/*
 	  This actually configures the PCMCIA socket -- setting up
 	  the I/O windows and the interrupt mapping, and putting the
 	  card and host interface into "Memory and IO" mode.
 	*/
-	CS_CHECK(RequestConfiguration, pcmcia_request_configuration(link, &link->conf));
-	((local_info_t*)link->priv)->eth_dev = 
+	CS_CHECK(RequestConfiguration,
+		 pcmcia_request_configuration(link, &link->conf));
+	((local_info_t*)link->priv)->eth_dev =
 		init_airo_card( link->irq.AssignedIRQ,
 				link->io.BasePort1, 1, &handle_to_dev(link) );
 	if (!((local_info_t*)link->priv)->eth_dev) goto cs_failed;
-	
+
 	/*
 	  At this point, the dev_node_t structure(s) need to be
 	  initialized and arranged in a linked list at link->dev_node.
@@ -344,7 +346,7 @@ static int airo_config(struct pcmcia_device *link)
 	strcpy(dev->node.dev_name, ((local_info_t*)link->priv)->eth_dev->name );
 	dev->node.major = dev->node.minor = 0;
 	link->dev_node = &dev->node;
-	
+
 	/* Finally, report what we've done */
 	printk(KERN_INFO "%s: index 0x%02x: ",
 	       dev->node.dev_name, link->conf.ConfigIndex);
@@ -374,11 +376,11 @@ static int airo_config(struct pcmcia_device *link)
 } /* airo_config */
 
 /*======================================================================
-  
+
   After a card is removed, airo_release() will unregister the
   device, and release the PCMCIA configuration.  If the device is
   still open, this will be postponed until it is closed.
-  
+
   ======================================================================*/
 
 static void airo_release(struct pcmcia_device *link)
@@ -475,7 +477,7 @@ static void airo_cs_cleanup(void)
     HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
     STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
     IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-    POSSIBILITY OF SUCH DAMAGE.    
+    POSSIBILITY OF SUCH DAMAGE.
 */
 
 module_init(airo_cs_init);

--------------010807080104060105000604--
