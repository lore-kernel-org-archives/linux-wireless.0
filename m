Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64153 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab2DTPsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 11:48:55 -0400
Received: by eaaq12 with SMTP id q12so2545063eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 08:48:54 -0700 (PDT)
Date: Fri, 20 Apr 2012 17:48:23 +0200
From: Anisse Astier <anisse@astier.eu>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v3 1/2] rt2x00: debugfs support - allow a register to be
 empty
Message-ID: <20120420174823.7a0e0921@destiny.ordissimo> (sfid-20120420_174859_561689_555CFC93)
In-Reply-To: <CAOZOX0XppHercdP64G+pOTxrzz6H0UNsr0Bkw6TzkGW_MNZJiw@mail.gmail.com>
References: <CAOZOX0UXc0OwhWOiM0PWbGfyynmrQ4kZRAVFJyxtiHe-veUg=g@mail.gmail.com>
	<1334843590-7920-1-git-send-email-anisse@astier.eu>
	<CAOZOX0XppHercdP64G+pOTxrzz6H0UNsr0Bkw6TzkGW_MNZJiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 20 Apr 2012 09:03:00 +0200, Ivo Van Doorn <ivdoorn@gmail.com> wrote :

> Hi,
> 
> I'm almost completely happy with this patch. :)
> 
> > @@ -694,25 +693,29 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
> >        if (IS_ERR(intf->register_folder) || !intf->register_folder)
> >                goto exit;
> >
> > -#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)    \
> > -({                                                             \
> > -       (__intf)->__name##_off_entry =                          \
> > -           debugfs_create_u32(__stringify(__name) "_offset",   \
> > -                              S_IRUSR | S_IWUSR,               \
> > -                              (__intf)->register_folder,       \
> > -                              &(__intf)->offset_##__name);     \
> > -       if (IS_ERR((__intf)->__name##_off_entry)                \
> > -                       || !(__intf)->__name##_off_entry)       \
> > -               goto exit;                                      \
> > -                                                               \
> > -       (__intf)->__name##_val_entry =                          \
> > -           debugfs_create_file(__stringify(__name) "_value",   \
> > -                               S_IRUSR | S_IWUSR,              \
> > -                               (__intf)->register_folder,      \
> > -                               (__intf), &rt2x00debug_fop_##__name);\
> > -       if (IS_ERR((__intf)->__name##_val_entry)                \
> > -                       || !(__intf)->__name##_val_entry)       \
> > -               goto exit;                                      \
> > +#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)                    \
> > +({                                                                             \
> > +       if(debug->__name.read) {                                                \
> > +               (__intf)->__name##_off_entry =                                  \
> > +               debugfs_create_u32(__stringify(__name) "_offset",               \
> > +                                      S_IRUSR | S_IWUSR,                       \
> > +                                      (__intf)->register_folder,               \
> > +                                      &(__intf)->offset_##__name);             \
> > +               if (IS_ERR((__intf)->__name##_off_entry)                        \
> > +                               || !(__intf)->__name##_off_entry)               \
> > +                       goto exit;                                              \
> > +                                                                               \
> > +               (__intf)->__name##_val_entry =                                  \
> > +               debugfs_create_file(__stringify(__name) "_value",               \
> > +                                       S_IRUSR | S_IWUSR,                      \
> > +                                       (__intf)->register_folder,              \
> > +                                       (__intf), &rt2x00debug_fop_##__name);   \
> > +               if (IS_ERR((__intf)->__name##_val_entry)                        \
> > +                               || !(__intf)->__name##_val_entry)               \
> > +                       goto exit;                                              \
> > +       } else                                                                  \
> > +               DEBUG(rt2x00dev, "Unsupported register on this device: "        \
> > +                       __stringify(__name) "\n");                              \
> >  })
> 
> I don't think we need to print error messages to the log, this will
> only confuse users.
> The driver intentionally didn't register the register type, so it is
> not worth the warning to the user.
> 
> Ivo

Sure :-)

From: Anisse Astier <anisse@astier.eu>
Date: Thu, 19 Apr 2012 15:04:52 +0200
Subject: [PATCH v4 1/2] rt2x00: debugfs support - allow a register to be empty

Allow a register to be unspecified, therefore not creating its debugfs
file entry.

Signed-off-by: Anisse Astier <anisse@astier.eu>
---
Changes since v3:
 - Don't print a debug message when register type isn't registered
---
 drivers/net/wireless/rt2x00/rt2x00debug.c |   71 +++++++++++++++--------------
 1 file changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 78787fc..5bb1221 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -624,22 +624,21 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
 	data += sprintf(data, "revision:\t%04x\n", intf->rt2x00dev->chip.rev);
 	data += sprintf(data, "\n");
 	data += sprintf(data, "register\tbase\twords\twordsize\n");
-	data += sprintf(data, "csr\t%d\t%d\t%d\n",
-			debug->csr.word_base,
-			debug->csr.word_count,
-			debug->csr.word_size);
-	data += sprintf(data, "eeprom\t%d\t%d\t%d\n",
-			debug->eeprom.word_base,
-			debug->eeprom.word_count,
-			debug->eeprom.word_size);
-	data += sprintf(data, "bbp\t%d\t%d\t%d\n",
-			debug->bbp.word_base,
-			debug->bbp.word_count,
-			debug->bbp.word_size);
-	data += sprintf(data, "rf\t%d\t%d\t%d\n",
-			debug->rf.word_base,
-			debug->rf.word_count,
-			debug->rf.word_size);
+#define RT2X00DEBUGFS_SPRINTF_REGISTER(__name)			\
+{								\
+	if(debug->__name.read)					\
+		data += sprintf(data, __stringify(__name)	\
+				"\t%d\t%d\t%d\n",		\
+				debug->__name.word_base,	\
+				debug->__name.word_count,	\
+				debug->__name.word_size);	\
+}
+	RT2X00DEBUGFS_SPRINTF_REGISTER(csr);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(eeprom);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(bbp);
+	RT2X00DEBUGFS_SPRINTF_REGISTER(rf);
+#undef RT2X00DEBUGFS_SPRINTF_REGISTER
+
 	blob->size = strlen(blob->data);
 
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
@@ -694,25 +693,27 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 	if (IS_ERR(intf->register_folder) || !intf->register_folder)
 		goto exit;
 
-#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)	\
-({								\
-	(__intf)->__name##_off_entry =				\
-	    debugfs_create_u32(__stringify(__name) "_offset",	\
-			       S_IRUSR | S_IWUSR,		\
-			       (__intf)->register_folder,	\
-			       &(__intf)->offset_##__name);	\
-	if (IS_ERR((__intf)->__name##_off_entry)		\
-			|| !(__intf)->__name##_off_entry)	\
-		goto exit;					\
-								\
-	(__intf)->__name##_val_entry =				\
-	    debugfs_create_file(__stringify(__name) "_value",	\
-				S_IRUSR | S_IWUSR,		\
-				(__intf)->register_folder,	\
-				(__intf), &rt2x00debug_fop_##__name);\
-	if (IS_ERR((__intf)->__name##_val_entry)		\
-			|| !(__intf)->__name##_val_entry)	\
-		goto exit;					\
+#define RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(__intf, __name)			\
+({										\
+	if(debug->__name.read) {						\
+		(__intf)->__name##_off_entry =					\
+		debugfs_create_u32(__stringify(__name) "_offset",		\
+				       S_IRUSR | S_IWUSR,			\
+				       (__intf)->register_folder,		\
+				       &(__intf)->offset_##__name);		\
+		if (IS_ERR((__intf)->__name##_off_entry)			\
+				|| !(__intf)->__name##_off_entry)		\
+			goto exit;						\
+										\
+		(__intf)->__name##_val_entry =					\
+		debugfs_create_file(__stringify(__name) "_value",		\
+					S_IRUSR | S_IWUSR,			\
+					(__intf)->register_folder,		\
+					(__intf), &rt2x00debug_fop_##__name);	\
+		if (IS_ERR((__intf)->__name##_val_entry)			\
+				|| !(__intf)->__name##_val_entry)		\
+			goto exit;						\
+	}									\
 })
 
 	RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, csr);
-- 
1.7.9.4

