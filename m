Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:35180 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab1EQTcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 15:32:11 -0400
Date: Tue, 17 May 2011 12:31:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] proc_fs: add stub for proc_mkdir_mode
Message-Id: <20110517123153.6fed984d.randy.dunlap@oracle.com> (sfid-20110517_213232_852685_21A7BAE5)
In-Reply-To: <20110517142749.8927b65b.sfr@canb.auug.org.au>
References: <20110517142749.8927b65b.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Provide a stub for proc_mkdir_mode() when CONFIG_PROC_FS is not
enabled, just like the stub for proc_mkdir().

Fixes this build error:
drivers/net/wireless/airo.c:4504: error: implicit declaration of function 'proc_mkdir_mode'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/proc_fs.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20110517.orig/include/linux/proc_fs.h
+++ linux-next-20110517/include/linux/proc_fs.h
@@ -210,6 +210,8 @@ static inline struct proc_dir_entry *pro
 		struct proc_dir_entry *parent,const char *dest) {return NULL;}
 static inline struct proc_dir_entry *proc_mkdir(const char *name,
 	struct proc_dir_entry *parent) {return NULL;}
+static inline struct proc_dir_entry *proc_mkdir_mode(const char *name,
+	mode_t mode, struct proc_dir_entry *parent) { return NULL; }
 
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
